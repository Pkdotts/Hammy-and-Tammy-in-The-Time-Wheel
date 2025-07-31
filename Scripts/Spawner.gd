extends Node2D
class_name Spawner

@export var auto_parent = true
@export var spawned_object : PackedScene
var new_parent: Node2D

func _ready() -> void:
	if auto_parent:
		new_parent = get_parent().get_parent()


func set_new_parent(parent: Node2D) -> void:
	new_parent = parent

func spawn_object(object: PackedScene = spawned_object) -> Node2D:
	if object != null and new_parent != null:
		var new_object = object.instantiate()
		new_parent.add_child(new_object)
		new_object.set_global_position(global_position)
		return new_object
	if object == null:
		print("Your object is null!")
	if new_parent == null:
		print("Your parent is null!")
	return null
