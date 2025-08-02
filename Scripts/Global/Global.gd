extends Node

var persist_camera = null
var current_hammy: Player
var _current_scene: Node

var got_cheese := false

@onready var _hammy_node = load("res://Nodes/Characters/Hammy.tscn")

func _ready():
	var root = get_tree().get_root()
	_current_scene = root.get_child(root.get_child_count() - 1)
	current_hammy = _hammy_node.instantiate()

func save():
	var save_dict = {}
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


func change_scenes(map):
	UiCanvasLayer.circle_transition()
	await UiCanvasLayer.transition.transition_finished
	get_tree().change_scene_to_file(map)

func get_current_scene() -> Node:
	return _current_scene