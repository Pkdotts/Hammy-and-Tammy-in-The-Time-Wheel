extends Camera2D
class_name Camera

@export var _attached_node: Player

@export var _cam_offset = Vector2(0, -300)

func _ready():
	Global.persist_camera = self
	teleport_to_node()

func _physics_process(delta):
	var max_y = _attached_node.DEATH_ZONE + _cam_offset.y - get_viewport_rect().size.y / 2

	var target_pos = _attached_node.global_position
	target_pos.y = min(target_pos.y, max_y)

	var new_position = target_pos + _cam_offset
	var lerp_position = global_position.lerp(new_position, delta * 10)
	
	global_position.x = lerp_position.x
	#if _attached_node.is_on_floor():
	global_position.y = lerp_position.y

func teleport_to_node():
	global_position = _attached_node.global_position + _cam_offset

#func shake(direction := Vector2.ONE, magnitude := 1.0, time := 1.0, interval := 0.2, side_amplitude := Vector2.ONE):
	#Shaker.new(self, "offset", direction, magnitude, time, interval, side_amplitude)

func shake_camera( direction = Vector2.ONE, magnitude = 1.0, time = 1.0):
	var old_offset = offset
	var shake = magnitude
	if shake < 1.0:
		shake = 1.0
	if time < 0.2:
		time = 0.2
	for i in int(time / .02):
		var tween = get_tree().create_tween()
		var new_offset = Vector2.ZERO
		if direction != Vector2.ZERO:
			if abs(shake) > 1:
				shake = shake * -1
				magnitude = magnitude * -1
			else:
				if shake < 0.5:
					shake = 1.0
				else:
					shake = 0.0
			new_offset = Vector2(shake, shake) * direction
		else:
			direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
			new_offset = direction * magnitude
		#offset = new_offset
		
		tween.tween_property(self, "offset", new_offset, 0.02)
		
		await get_tree().create_timer(.02).timeout
		if abs(shake) > 1:
			shake -= magnitude / int(time / .02)
			
	offset = old_offset
