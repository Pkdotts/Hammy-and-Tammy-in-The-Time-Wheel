extends Node2D

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
	await get_tree().process_frame
	$AnimationTree.active = true

func _flip(enabled: bool):
	$Sprite.flip_h = enabled

func _physics_process(delta: float) -> void:
	
	if Global.current_hammy.visible:
		var input_direction = _get_controls_direction()
		_movement(input_direction, delta)
	else:
		animationState.travel("Horrified")
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
			AudioManager.play_sfx("walk", "wheel")
		elif spin_direction < 0:
			AudioManager.play_sfx("walk", "wheel")
	else:
		AudioManager.stop_sfx("wheel")

func _add_time(amount: int, delta: float = 1.0):
	TimeManager.add_time(amount * spin_direction * spin_speed * delta)
	_update_clock()

func _set_time(amount: int):
	TimeManager.set_time(amount)
	await get_tree().process_frame
	_update_clock()

func _spin_wheel(delta: float) -> void:
	$Wheel.rotation += spin_direction * spin_speed * delta

func _update_clock():
	$TammyWheelArrow.rotation = deg_to_rad(TimeManager.get_point_in_time(360))


func _get_controls_direction() -> float:
	var direction = 0.0
	direction += Input.get_action_strength("ui_focus_next")
	direction -= Input.get_action_strength("ui_focus_prev")
	return direction
