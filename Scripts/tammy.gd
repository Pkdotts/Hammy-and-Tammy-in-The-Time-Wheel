extends Node2D

var active = false
var inputDirection := 0.0

var spin_speed = 0.0
var spin_direction =0.0

const START_TIME = 100.0
const MAX_SPEED = 8.0
const ACCELERATION = 25.0
const DECELERATION = 5.0
const TURN_SPEED = 0.2


func _ready() -> void:
	await get_tree().process_frame
	TimeManager.add_time(100)

func _physics_process(delta: float) -> void:
	_controls()
	_movement(delta)

func _movement(delta):
	if inputDirection != 0:
		if spin_speed < MAX_SPEED:
			spin_speed += ACCELERATION * delta
		else:
			spin_speed = MAX_SPEED
	elif spin_speed > 0:
		spin_speed -= DECELERATION * delta
		if spin_speed <= 0:
			spin_speed = 0
	
	if spin_speed != 0:
		spin_direction = lerp(spin_direction, inputDirection, TURN_SPEED)
		
	else:
		spin_direction = inputDirection
	
	if spin_speed > 0:
		_add_time(50, delta)
		_spin_wheel(delta)

func _add_time(amount, delta = 1):
	TimeManager.add_time(amount * spin_direction * spin_speed * delta)
	_update_clock()

func _set_time(amount):
	TimeManager.set_time(amount)
	_update_clock()

func _spin_wheel(delta):
	$Wheel.rotation += spin_direction * spin_speed * delta

func _update_clock():
	$Label.text = "Time: " + str(TimeManager.get_current_time())


func _controls():
	inputDirection = 0
	inputDirection += Input.get_action_strength("ui_focus_next")
	inputDirection -= Input.get_action_strength("ui_focus_prev")
	
	#
	#if Input.is_action_just_pressed("ui_select"):
		#active = !active
