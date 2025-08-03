extends Control

func _ready() -> void:
	AudioManager.play_music("title_screen")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_start_game()

func _start_game():
	UiCanvasLayer.fade_transition()
	await UiCanvasLayer.transition.transition_finished
	Global.change_scenes("Intro")
