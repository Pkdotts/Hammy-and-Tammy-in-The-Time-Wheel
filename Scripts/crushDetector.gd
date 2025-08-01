extends RayCast2D
class_name CrushDetector

signal crushed

@export var checking = true

func _process(_delta: float) -> void:
	var even_collide = 0
	var uneven_collide = 0
	if checking:
		for i in 4:
			target_position = target_position.rotated(deg_to_rad(90))
			if get_collider() != null:
				if i%2 == 0:
					even_collide += 1
				else:
					uneven_collide += 1
		
		if uneven_collide or even_collide == 2:
			emit_signal("crushed")
