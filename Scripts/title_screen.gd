extends Control

var active = false
var seq = ""
#var tween = create_tween()
var soundEffects = {
}


func _input(event):
	if event.is_action_pressed("ui_space"):
		get_tree().change_scene_to_file("res://Maps/Level 1.tscn")
