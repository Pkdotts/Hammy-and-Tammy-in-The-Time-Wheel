extends Area2D

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Global.get_current_level().hit_checkpoint(self)
