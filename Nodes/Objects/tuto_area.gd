extends Area2D

@export_multiline var text := ""
@export var action := ""

func _ready() -> void:
	$Label.text = text % _get_physical_key_name_for_action(action)
	$Label.modulate.a = 0.0

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not Global.got_cheese:
		var tween = get_tree().create_tween()
		tween.tween_property($Label, "modulate:a", 1.0, 0.5)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		var tween = get_tree().create_tween()
		tween.tween_property($Label, "modulate:a", 0.0, 0.5)


func _get_physical_key_name_for_action(action_name: String) -> String:
	var events = InputMap.action_get_events(action_name)
	
	for event in events:
		if event is InputEventKey and event.physical_keycode != 0:
			var keycode = DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
			return OS.get_keycode_string(keycode)
	
	return ""
