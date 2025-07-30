extends Node2D

var active = false
var inputVector := Vector2.ZERO

const SPIN_SPEED = 30.0

func _physics_process(delta: float) -> void:
	if active:
		if inputVector.x != 0:
			$Wheel.rotation += inputVector.x * SPIN_SPEED * delta


func _controls():
	inputVector = ControlsManager.get_controls_vector()
