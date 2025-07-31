extends Node

var persistCamera = null
var currentHammy : Player
var currentScene

func save():
	var save_dict = {
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

func goto_scene(path, playerPosition = Vector2.ZERO, playerDirection = Vector2(0,1)):
	call_deferred("_deferred_goto_scene", path, playerPosition, playerDirection)

func _deferred_goto_scene(path, playerPosition, playerDirection):
	if currentScene.has_node("YSort"):
		currentScene.get_node("YSort").remove_child(currentHammy)
	else:
		currentScene.get_node("Objects").remove_child(currentHammy)
	
	# This could be moved somewhere else for better code organization
	# var ao_oni
	# ao_oni = currentScene.get_node("Objects").get_node_or_null("AoOni")
	# if ao_oni != null:
	# 	ao_oni = ao_oni.duplicate()
	
	currentHammy.set_all_collisions(false)
	
	var new_scene = ResourceLoader.load(path).instance()

	if currentScene:
		currentScene.leave_for(new_scene)
	
	currentScene.free()

	currentScene = new_scene
	
	get_tree().get_root().add_child(currentScene)
	
	if currentScene.has_node("YSort"):
		currentScene.get_node("YSort").add_child(currentHammy)
	else:
		currentScene.get_node("Objects").add_child(currentHammy)
	
	get_tree().set_current_scene(currentScene)
	await get_tree().process_frame
	
	currentHammy.set_all_collisions(true)
