extends CanvasLayer

@onready var transition_ui = preload("res://UI/Transition.tscn")
@onready var tammy_ui = preload("res://UI/TammyUI.tscn")
@onready var vignette_ui = preload("res://UI/vignette.tscn")

var transition : Transition = null
var tammy : Tammy = null
var vignette = null

func add_tammy_ui():
	erase_tammy_ui()
	tammy = tammy_ui.instantiate()
	add_child(tammy)

func erase_tammy_ui():
	if tammy != null:
		tammy.queue_free()
		tammy = null

func add_vignette_ui():
	erase_vignette_ui()
	vignette = vignette_ui.instantiate()
	add_child(vignette)

func erase_vignette_ui():
	if vignette != null:
		vignette.queue_free()
		vignette = null

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

func fade_in():
	erase_transition()
	var transitionUI = transition_ui.instantiate()
	add_child(transitionUI)
	transition = transitionUI
	transition.fadein()

func fade_out():
	if transition != null:
		transition.fadeout()
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

func fade_transition():
	if transition == null:
		var transitionUI = transition_ui.instantiate()
		add_child(transitionUI)
		transition = transitionUI
		transition.fadein()
		await transition.transition_finished
		transition.fadeout()
		await transition.transition_finished
		remove_transition()
