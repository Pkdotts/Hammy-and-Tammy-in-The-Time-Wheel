extends Area2D

@export_multiline var text: String = ""

func _ready() -> void:
	$Label.text = text
	$Label.modulate.a = 0.0

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not Global.got_cheese:
		var tween = get_tree().create_tween()
		tween.tween_property($Label, "modulate:a", 1.0, 0.5)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		var tween = get_tree().create_tween()
		tween.tween_property($Label, "modulate:a", 0.0, 0.5)
