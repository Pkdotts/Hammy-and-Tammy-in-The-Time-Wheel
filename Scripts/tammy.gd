class_name Tammy extends Node2D

var active := false

var spin_speed := 0.0
var spin_direction := 0.0

const START_TIME := 100.0
const MAX_SPEED := 8.0
const ACCELERATION := 25.0
const DECELERATION := 4.5
const TURN_SPEED := 0.2

const SPIN_SPEED_SFX_THRESHOLD := 0.1

@onready var animationState = $AnimationTree["parameters/playback"]

func _ready() -> void:
	$AnimationTree.active = true
	Global.current_tammy = self
	TimeManager.connect("time_changed", _update_clock)
	_update_clock()

func _flip(enabled: bool):
	$Sprite.flip_h = enabled

func _physics_process(delta: float) -> void:
	if Global.current_hammy.is_active():
		var input_direction = _get_controls_direction()
		_movement(input_direction, delta)
		#_animation_tree()
#
#func _animation_tree():
	#
	#$AnimationTree.set("parameters/conditions/running", input_direction != 0)
	#print($AnimationTree["parameters/conditions/running"])
	

func _movement(input_direction: float, delta: float) -> void:
	if input_direction != 0:
		animationState.travel("Run")
		if spin_speed < MAX_SPEED:
			spin_speed += ACCELERATION * delta
		else:
			spin_speed = MAX_SPEED
	elif spin_speed > 0:
		spin_speed -= DECELERATION * delta
		if spin_speed <= 0:
			spin_speed = 0
		animationState.travel("Idle")
	
	if spin_speed != 0 and spin_direction != input_direction:
		spin_direction = lerp(spin_direction, input_direction, TURN_SPEED)
		$Sprite.flip_h = spin_direction < 0
	else:
		spin_direction = input_direction
	
	if spin_speed > 0:
		_add_time(50, delta)
		_spin_wheel(delta)

	if spin_speed * delta > SPIN_SPEED_SFX_THRESHOLD:
		if spin_direction > 0:
			AudioManager.play_sfx("wheel", "wheel")
			AudioManager.play_sfx("forward", "time")
		elif spin_direction < 0:
			AudioManager.play_sfx("wheel", "wheel")
			AudioManager.play_sfx("rewind", "time")
	else:
		AudioManager.stop_sfx("wheel", true)
		AudioManager.stop_sfx("time")

func hammy_died():
	animationState.travel("Horrified")

func reset():
	spin_speed = 0.0
	spin_direction = 0.0
	animationState.travel("Idle")
	_set_time(105)

func _add_time(amount: int, delta: float = 1.0):
	TimeManager.add_time(amount * spin_direction * spin_speed * delta)

func _set_time(amount: int):
	TimeManager.set_time(amount)
	await get_tree().process_frame

func _spin_wheel(delta: float) -> void:
	$Wheel.rotation += spin_direction * spin_speed * delta

func _update_clock():
	$TammyWheelArrow.rotation = deg_to_rad(TimeManager.get_point_in_time(360))


func _get_controls_direction() -> float:
	var direction = 0.0
	direction += Input.get_action_strength("ui_focus_next")
	direction -= Input.get_action_strength("ui_focus_prev")
	return direction
