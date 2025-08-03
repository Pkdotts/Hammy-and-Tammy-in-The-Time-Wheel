extends Sprite2D


func _on_static_body_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Global.got_cheese = true
		queue_free()
