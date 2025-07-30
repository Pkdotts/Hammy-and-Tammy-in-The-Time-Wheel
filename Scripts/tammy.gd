extends Node2D

var active = false
var inputVector := Vector2.ZERO

const SPIN_SPEED = 10.0


func _physics_process(delta: float) -> void:
	_controls()
	if active:
		if inputVector.x != 0:
			$Wheel.rotation += inputVector.x * SPIN_SPEED * delta
			TimeManager.add_time(50 * SPIN_SPEED * delta)
			$Label.text = "Time: " + str(TimeManager.get_current_time())
	


func _controls():
	inputVector = ControlsManager.get_controls_vector()
	if Input.is_action_just_pressed("ui_select"):
		active = !active
