extends CharacterBody2D
class_name Player

var inputVector := Vector2.ZERO
var direction := Vector2.ZERO

var active := true

var walk_speed = 0

const GRAVITY := 4000.0
const MAX_FALL_SPEED := 500.0
const MAX_WALK_SPEED := 400.0
const WALK_ACCELERATION := 3000.0
const WALK_DECELERATION := 1600.0
const JUMP_FORCE := 1200.0
const COYOTE_TIME := 0.2

var floor_time := 0.0

func _ready() -> void:
	Global.currentHammy = self

func _physics_process(delta: float) -> void:
	if active:
		_controls()
	_movement(delta)
	_gravity(delta)
	_jump(delta)
	move_and_slide()
		
	if Input.is_action_just_pressed("ui_select"):
		active = !active
		inputVector = Vector2.ZERO

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
		if walk_speed < MAX_WALK_SPEED:
			walk_speed += WALK_ACCELERATION * delta
	elif walk_speed > 0:
		walk_speed -= WALK_ACCELERATION * delta
		if walk_speed <= 0:
			walk_speed = 0
	velocity.x = direction.x * walk_speed
	

func _jump(delta):
	if can_jump() and $BufferTimer.time_left > 0.0:
		velocity.y = -JUMP_FORCE
		floor_time = COYOTE_TIME
		

func _gravity(delta):
	if !is_on_floor():
		if can_jump():
			floor_time += delta
		velocity.y += delta * GRAVITY
		if velocity.y >= GRAVITY:
			velocity.y = GRAVITY
	else:
		floor_time = 0
		velocity.y = 0

func can_jump():
	return floor_time < COYOTE_TIME

func stop_jump():
	if velocity.y < 0:
		velocity.y /= 2
