extends Control

func _ready() -> void:
	AudioManager.play_music("hamster_moog")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_start_game()

func _start_game():
	AudioManager.fadeout_music()
	UiCanvasLayer.circle_transition()
	await UiCanvasLayer.transition.transition_finished
	Global.change_scenes("Intro")
