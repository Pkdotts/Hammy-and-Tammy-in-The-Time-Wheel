extends CanvasLayer

@onready var transition_ui = preload("res://UI/Transition.tscn")
@onready var tammy_ui = preload("res://Nodes/Characters/Tammy.tscn")


var transition : Transition = null

func erase_transition():
	if transition != null:
		transition.queue_free()
		transition = null

func circle_in():
	erase_transition()
	var transitionUI = transition_ui.instantiate()
	add_child(transitionUI)
	transition = transitionUI
	transition.circlein()

func circle_out():
	if transition != null:
		transition.circleout()
		transition.connect("transition_finished", remove_transition)

func remove_transition():
	transition.queue_free()
	transition = null

func circle_transition():
	if transition == null:
		var transitionUI = transition_ui.instantiate()
		add_child(transitionUI)
		transition = transitionUI
		transition.circlein()
		await transition.transition_finished
		transition.circleout()
		await transition.transition_finished
		remove_transition()
