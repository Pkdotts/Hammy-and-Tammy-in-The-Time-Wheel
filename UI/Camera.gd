extends Camera2D

@export var attachedNode: Player

@export var camOffset = Vector2(0, -300)

func _ready():
	Global.persistCamera = self

func _physics_process(delta):
	var newPosition = attachedNode.global_position + camOffset
	var lerpPosition = global_position.lerp(newPosition, delta * 10)
	

	global_position.x = lerpPosition.x
	#if attachedNode.is_on_floor():
	global_position.y = lerpPosition.y

func teleport_to_node():
	global_position.x = attachedNode.global_position.x + camOffset.x

func shake_camera(magnitude = 1.0, time = 1.0, direction = Vector2.ONE):
	var old_offset = offset
	var shake = magnitude
	if shake < 1.0:
		shake = 1.0
	if time < 0.2:
		time = 0.2
	for i in int(time / .02):
		var tween = get_tree().create_tween()
		var new_offset = Vector2.ZERO
		if abs(shake) > 1:
			shake = shake * -1
			magnitude = magnitude * -1
		else:
			if shake < 0.5:
				shake = 1.0
			else:
				shake = 0.0
		new_offset = Vector2(shake, shake) * direction
		#offset = new_offset
		
		tween.tween_property(self, "offset", new_offset, 0.02)
		
		await get_tree().create_timer(.02).timeout
		if abs(shake) > 1:
			shake -= magnitude / int(time / .02)
			
	offset = old_offset
