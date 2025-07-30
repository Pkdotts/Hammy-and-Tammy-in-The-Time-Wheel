extends CanvasLayer

@onready var transition_ui = preload("res://UI/Transition.tscn")
@onready var gamehud_ui = preload("res://UI/GameHud.tscn")
@onready var title_ui = preload("res://UI/Title.tscn")
@onready var tutorial_ui = preload("res://Scripts/UI/Tutorials.tscn")
@onready var gameover_ui = preload("res://UI/GameOver.tscn")

var title : Title = null
var transition : Transition = null
var gamehud : GameHud = null
var tutorial : Tutorial = null
var gameover : GameOver = null

func add_title_ui():
	erase_title_ui()
	title = title_ui.instantiate()
	add_child(title)

func erase_title_ui():
	if title != null:
		title.queue_free()
		title = null

func add_gamehud_ui():
	erase_gamehud()
	gamehud = gamehud_ui.instantiate()
	add_child(gamehud)

func erase_gamehud():
	if gamehud != null:
		gamehud.queue_free()
		gamehud = null

func add_tutorial_ui():
	erase_tutorial()
	tutorial = tutorial_ui.instantiate()
	add_child(tutorial)

func show_tutorial(tut: int):
	if tutorial != null:
		tutorial.show_tutorial(tut)

func hide_tutorial(tut: int):
	if tutorial != null:
		tutorial.hide_tutorial(tut)

func hide_all_tutorials():
	if tutorial != null:
		tutorial.hide_all()

func erase_tutorial():
	if tutorial != null:
		tutorial.queue_free()
		tutorial = null

func update_hp():
	if gamehud != null:
		print("ui canvas update hp")
		gamehud.update_hp()

func update_scrap_bar(time: float = 0.1):
	if gamehud != null:
		print("ui canvas update bar")
		gamehud.update_bar(time)

func add_gameover_ui():
	erase_gameover()
	gameover = gameover_ui.instantiate()
	add_child(gameover)

func erase_gameover():
	if gameover != null:
		gameover.queue_free()
		gameover = null

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
