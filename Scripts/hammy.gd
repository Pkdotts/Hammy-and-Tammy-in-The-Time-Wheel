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
var _respawn_point = Vector2.ZERO
var in_front_of_door := false

func _ready() -> void:
	Global.current_hammy = self
	_respawn_point = global_position

func _physics_process(delta: float) -> void:
	if _action_started:
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
			stop_jump()
	


func _movement(delta):
	if inputVector != Vector2.ZERO:
		animationState.travel("Run")
		if !at_peak():
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
	if can_jump() and $BufferTimer.time_left > 0.0:
		velocity.y = -JUMP_FORCE
		floor_time = COYOTE_TIME
		

func _gravity(delta):
	if !is_on_floor():
		if can_jump():
			floor_time += delta
		
		if at_peak():
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
		UiCanvasLayer.circle_in()
		await UiCanvasLayer.transition.transition_finished
		_return_to_respawn()

func set_respawn(point):
	_respawn_point = point

func _return_to_respawn():
	global_position = _respawn_point
	show()
	UiCanvasLayer.circle_out()
	await UiCanvasLayer.transition.transition_finished
	_action_started = true

func pause(): #idk if we're gonna need this tho
	_paused = true
	emit_signal("paused")

func unpause():
	_paused = false
	emit_signal("unpaused")

func is_active() -> bool:
	return _action_started and not _paused

func stop_jump():
	if velocity.y < 0:
		velocity.y *= JUMP_STOP

func can_jump():
	return (floor_time < COYOTE_TIME) and !in_front_of_door

func at_peak() -> bool:
	return abs(velocity.y) < PEAK_VELOCITY

func _on_crush_detector_crushed() -> void:
	if _action_started:
		_die()

func create_teleport_effect() -> void:
	$Spawner.spawn_object()
