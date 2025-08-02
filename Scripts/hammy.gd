extends CharacterBody2D
class_name Player

@onready var animationState = $AnimationTree["parameters/playback"]

var inputVector := Vector2.ZERO
var direction := Vector2.ZERO

var active := true

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

const JUMP_STOP := 0.35

const COYOTE_TIME := 0.2

var floor_time := 0.0
var respawnPoint = Vector2.ZERO
var in_front_of_door := false

func _ready() -> void:
	Global.currentHammy = self
	respawnPoint = global_position

func _physics_process(delta: float) -> void:
	#if active:
	_controls()
	_movement(delta)
	_gravity(delta)
	_jump(delta)
	move_and_slide()
		
	#if Input.is_action_just_pressed("ui_select"):
		#active = !active
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
	

func _jump(delta):
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
	else:
		floor_time = 0
		#elocity.y = GRAVITY/30
		velocity.y = 0

func die():
	if active:
		active = false
		hide()
		UiCanvasLayer.circle_in()
		await UiCanvasLayer.transition.transition_finished
		return_to_respawn()
		UiCanvasLayer.circle_out()

func set_respawn(point):
	respawnPoint = point

func return_to_respawn():
	show()
	global_position = respawnPoint
	active = true

func pause(): #idk if we're gonna need this tho
	active = false
	emit_signal("paused")

func unpause():
	active = true
	emit_signal("unpaused")

func stop_jump():
	if velocity.y < 0:
		velocity.y *= JUMP_STOP

func can_jump():
	return (floor_time < COYOTE_TIME) and !in_front_of_door

func at_peak() -> bool:
	return abs(velocity.y) < PEAK_VELOCITY

func _on_crush_detector_crushed() -> void:
	if active:
		die()

func create_teleport_effect() -> void:
	$Spawner.spawn_object()
