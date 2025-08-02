extends Control

var active = false
var seq = ""
#var tween = create_tween()
var soundEffects = {
}

func _input(event):
	if event.is_action_pressed("ui_space"):
		_start_game()

func _start_game():
		UiCanvasLayer.circle_transition()
		await UiCanvasLayer.transition.transition_finished
		UiCanvasLayer.add_tammy_ui()
		get_tree().change_scene_to_file("res://Maps/Level1.tscn")
