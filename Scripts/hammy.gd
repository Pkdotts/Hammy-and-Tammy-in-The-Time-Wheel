extends CharacterBody2D

var inputVector := Vector2.ZERO
var direction := Vector2.ZERO

const GRAVITY = 500.0
const MAX_FALL_SPEED = 500.0
const WALK_SPEED = 100.0
const WALK_DECELERATION = 500
const JUMP_FORCE = 100.0



func _physics_process(delta: float) -> void:
	if ControlsManager.get_controls_vector() != Vector2.ZERO:
		inputVector.x = ControlsManager.get_controls_vector().x
	
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y -= JUMP_FORCE
	
	velocity.x = inputVector.x * WALK_SPEED
	
	if velocity.y >= GRAVITY:
		velocity.y = GRAVITY
	velocity.y += delta * GRAVITY

	var motion = velocity * delta
	move_and_collide(motion)
	move_and_slide()
	
