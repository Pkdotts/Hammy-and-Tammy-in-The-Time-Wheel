extends CharacterBody2D
class_name Player

@onready var animationState = $AnimationTree["parameters/playback"]

var inputVector := Vector2.ZERO
var direction := Vector2.ZERO

var _action_started := true
var _paused := false

var walk_speed := 0.0
var walk_direction := 0.0

signal paused
signal unpaused

const JUMP_FORCE := 1000.0
const GRAVITY := 4000.0
const PEAK_GRAVITY := 2500.0
const PEAK_VELOCITY := 100.0
const PEAK_MAX_WALK_SPEED := 450.0
const MAX_WALK_SPEED := 430.0
const MAX_FALL_SPEED := 100.0
const WALK_ACCELERATION := 3000.0
const WALK_DECELERATION := 1600.0
const GROUND_TURN_SPEED := 0.8
const AIR_TURN_SPEED := 0.4
const DEATH_ZONE := 4000.0

const JUMP_STOP := 0.35

const COYOTE_TIME := 0.2

var floor_time := 0.0
var in_front_of_door := false

var amount_colliding = 0

func _ready() -> void:
	Global.current_hammy = self
	global_position = Global.get_current_level().get_spawn_position()

func _physics_process(delta: float) -> void:
	if visible and is_active():
		_controls()
		_movement(delta)
		_gravity(delta)
		_jump(delta)
		move_and_slide()
		
	#if Input.is_action_just_pressed("ui_select"):
		#_action_started = !_action_started
		#inputVector = Vector2.ZERO

func _controls():
	inputVector = ControlsManager.get_controls_vector()
	if ControlsManager.get_controls_vector() != Vector2.ZERO:
		direction.x = inputVector.x
		
	if Input.is_action_just_pressed("ui_accept"):
		$BufferTimer.start()
	if Input.is_action_just_released("ui_accept"):
		if !is_on_floor():
			_stop_jump()
	


func _movement(delta):
	if inputVector != Vector2.ZERO:
		animationState.travel("Run")
		if !_at_peak():
			if walk_speed < MAX_WALK_SPEED:
				walk_speed += WALK_ACCELERATION * delta
		else:
			if walk_speed < PEAK_MAX_WALK_SPEED:
				walk_speed += WALK_ACCELERATION * delta
	elif walk_speed > 0:
		walk_speed -= WALK_ACCELERATION * delta
		if walk_speed <= 0:
			walk_speed = 0
		animationState.travel("Idle")
	if walk_speed != 0 and walk_direction != direction.x:
		if is_on_floor():
			walk_direction = lerp(walk_direction, direction.x, GROUND_TURN_SPEED)
		else:
			walk_direction = lerp(walk_direction, direction.x, AIR_TURN_SPEED)
		$Sprite.flip_h = walk_direction < 0
	else:
		walk_direction = direction.x
	velocity.x = walk_direction * walk_speed
	

func _jump(_delta):
	if _can_jump() and $BufferTimer.time_left > 0.0:
		$BufferTimer.stop()
		AudioManager.play_sfx("jump")
		velocity.y = -JUMP_FORCE
		floor_time = COYOTE_TIME

func hole():
	_action_started = false
	animationState.travel("Hole")


func _gravity(delta):
	if !is_on_floor():
		if _can_jump():
			floor_time += delta
		
		if _at_peak():
			velocity.y += delta * PEAK_GRAVITY
			
		else:
			velocity.y += delta * GRAVITY
		
		if velocity.y >= GRAVITY:
			velocity.y = GRAVITY

		if global_position.y > DEATH_ZONE:
			_die()

	else:
		floor_time = 0
		#elocity.y = GRAVITY/30
		velocity.y = 0

func _die():
	if _action_started:
		_action_started = false
		hide()
		_set_collisions(false)
		$Spawner.spawn_object()
		#Global.persist_camera.shake(Vector2.ZERO, 10000, 1, 0.2)
		#Global.persist_camera.shake_camera(Vector2.ZERO, 30, 0.4)
		inputVector = Vector2.ZERO
		direction = Vector2.ZERO
		animationState.travel("Idle")
		Global.current_tammy.hammy_died()
		await get_tree().create_timer(2).timeout
		UiCanvasLayer.circle_in()
		await UiCanvasLayer.transition.transition_finished
		Global.current_tammy.reset()
		_return_to_respawn()

func _set_collisions(enabled):
	set_collision_layer_value(1, enabled)
	set_collision_mask_value(1, enabled)
	

func _return_to_respawn(checkpoint: bool = true):
	global_position = Global.get_current_level().get_spawn_position(checkpoint)
	show()
	_set_collisions(true)
	UiCanvasLayer.circle_out()
	await UiCanvasLayer.transition.transition_finished
	Global.persist_camera.teleport_to_node()
	_action_started = true

func pause(): #idk if we're gonna need this tho
	animationState.travel("Idle")
	_paused = true
	emit_signal("paused")

func unpause():
	_paused = false
	emit_signal("unpaused")

func is_active() -> bool:
	return _action_started and not _paused

func _stop_jump():
	if velocity.y < 0:
		velocity.y *= JUMP_STOP

func _can_jump():
	return (floor_time < COYOTE_TIME or amount_colliding > 1)  and !in_front_of_door

func _at_peak() -> bool:
	return abs(velocity.y) < PEAK_VELOCITY

func _on_crush_detector_crushed() -> void:
	if _action_started:
		AudioManager.play_sfx("crushed")
		_die()
		

func create_teleport_effect() -> void:
	$Spawner.spawn_object()


func _on_area_2d_body_entered(body: Node2D) -> void:
	amount_colliding += 1


func _on_area_2d_body_exited(body: Node2D) -> void:
	amount_colliding -= 1
