extends Area2D

@export var _enabled_on_normal := true
@export var _enabled_on_reverted := true

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if (Global.got_cheese and _enabled_on_reverted) or (not Global.got_cheese and _enabled_on_normal):
			Global.get_current_level().hit_checkpoint(self)
