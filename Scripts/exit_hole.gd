extends Sprite2D

@export var backwards_door := false

func _ready() -> void:
	$Label.modulate.a = 0.0

func _is_active():
	return (Global.got_cheese == backwards_door)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if Global.current_hammy.in_front_of_door and _is_active():
			Global.get_current_level().end_level()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and _is_active():
		body.in_front_of_door = true
		var tween = get_tree().create_tween()
		tween.tween_property($Label, "modulate:a", 1.0, 0.5)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player and _is_active():
		body.in_front_of_door = false
		var tween = get_tree().create_tween()
		tween.tween_property($Label, "modulate:a", 0.0, 0.5)
