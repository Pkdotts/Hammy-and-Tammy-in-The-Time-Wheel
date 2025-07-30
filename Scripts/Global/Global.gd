extends Node

var persistCamera = null
var mainScene : MainScene = null
var persistPlayer : Player = null

signal updated_score
signal updated_level
signal game_overed
signal show_suck_tutorial

const PATTERNS = [
	[ # Difficulty 1
		preload("res://Nodes/EnemyPatterns/EP1_1.tscn"),
		preload("res://Nodes/EnemyPatterns/EP1_2.tscn"),
		preload("res://Nodes/EnemyPatterns/EP1_3.tscn")
	],[ #Difficulty 2
		preload("res://Nodes/EnemyPatterns/EP2_1.tscn"),
		preload("res://Nodes/EnemyPatterns/EP2_2.tscn")
	],[ #Difficulty 3
		preload("res://Nodes/EnemyPatterns/EP3_1.tscn"),
		preload("res://Nodes/EnemyPatterns/EP3_2.tscn"),
		preload("res://Nodes/EnemyPatterns/EP3_3.tscn")
	],[ #Difficulty 4
		preload("res://Nodes/EnemyPatterns/EP4_1.tscn"),
		preload("res://Nodes/EnemyPatterns/EP4_2.tscn")
	],[ #Difficulty 5
		preload("res://Nodes/EnemyPatterns/EP5_1.tscn"),
		preload("res://Nodes/EnemyPatterns/EP5_2.tscn")
	],[#Difficulty 6
		preload("res://Nodes/EnemyPatterns/EP6_1.tscn"),
		preload("res://Nodes/EnemyPatterns/EP6_2.tscn"),
		preload("res://Nodes/EnemyPatterns/EP6_3.tscn"),
		preload("res://Nodes/EnemyPatterns/EP4_1.tscn"),
		preload("res://Nodes/EnemyPatterns/EP4_2.tscn"),
		preload("res://Nodes/EnemyPatterns/EP3_1.tscn"),
		preload("res://Nodes/EnemyPatterns/EP3_2.tscn"),
		preload("res://Nodes/EnemyPatterns/EP3_3.tscn")
	]
]

const MAXHP : int = 6
var player_hp : int = 6

const START_SPEED = 20 # Originally 20
const SPEED_PER_DIFFICULTY = 3 # Originally 3

var speed : int = 0
const difficulty_speed_increment : int = 5
const MAX_LEVEL : int = 50

var score : int = 0
var highscore : int = 0

var gameover = false

var tutorial_passed = false

var timer: Timer

func _ready() -> void:
	AudioManager.play_title_music()
	load_game()



func start_game() -> void:
	player_hp = MAXHP
	AudioManager.play_game_music()
	UiCanvasLayer.add_gamehud_ui()

func check_and_show_tutorial(tut: int):
	if !tutorial_passed:
		print("global show " + str(tut))
		UiCanvasLayer.show_tutorial(tut)

func hide_tutorial(tut: int):
	UiCanvasLayer.hide_tutorial(tut)

func pass_tutorial():
	hide_tutorial(1)
	hide_tutorial(0)
	speed = difficulty_speed_increment
	tutorial_passed = true
	emit_signal("updated_level")

func set_gameover(enabled):
	gameover = enabled
	if enabled:
		UiCanvasLayer.hide_all_tutorials()
		UiCanvasLayer.gamehud.disappear()
		UiCanvasLayer.add_gameover_ui()
		AudioManager.play_title_music()

func return_to_title() -> void:
	UiCanvasLayer.circle_transition()
	await UiCanvasLayer.transition.transition_finished
	UiCanvasLayer.erase_gameover()
	get_tree().reload_current_scene()
	set_gameover(false)
	player_hp = MAXHP
	score = 0
	speed = 0

func add_hp(points) -> void:
	var new_hp = player_hp + points
	player_hp = max(min(new_hp, MAXHP), 0)
	UiCanvasLayer.update_hp()

func get_player_hp_percentage() -> float:
	return float(player_hp) / float(MAXHP)

func get_charge() -> int:
	return persistPlayer.charge



func add_level() -> void:
	if !gameover and tutorial_passed:
		speed += 1
		emit_signal("updated_level")

func add_score(amount):
	if !gameover and tutorial_passed:
		score += amount
		emit_signal("updated_score")

func reset_score():
	score = 0

func get_difficulty() -> int:
	var difficulty = speed / difficulty_speed_increment
	if difficulty > MAX_LEVEL:
		difficulty = MAX_LEVEL
	return difficulty

func save():
	var save_dict = {
		"tutorial_passed": tutorial_passed,
		"highscore": highscore
	}
	return save_dict

func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify(save())
	save_file.store_line(json_string)

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		tutorial_passed = json.data["tutorial_passed"]
		highscore = json.data["highscore"]
		
