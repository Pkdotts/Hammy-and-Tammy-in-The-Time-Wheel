extends Sprite2D

@export var backwards_door := false

func _is_active():
	return (Global.got_cheese == backwards_door)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if Global.current_hammy.in_front_of_door and _is_active():
			Global.get_current_level().end_level()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == Global.current_hammy:
		Global.current_hammy.in_front_of_door = true
		$Label.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == Global.current_hammy:
		Global.current_hammy.in_front_of_door = false
		$Label.visible = false
