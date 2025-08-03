extends Control

var finished = false

func _ready() -> void:
	_play_anim()

func _process(_delta: float) -> void:
	if finished and (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel")):
		goto_title()

func _play_anim() -> void:
	$AnimationPlayer.play("FadeIn") #Play all the animations
	
	finished = true

func goto_title():
	UiCanvasLayer.circle_transition()
	await UiCanvasLayer.transition.transition_finished
	Global.change_scenes("Title Screen")
	Global.reset_data()
