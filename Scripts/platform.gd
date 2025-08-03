extends Node2D
class_name AbstractPlatform

signal moved

@onready var sparkle = preload("res://Nodes/Effects/TeleportEffect.tscn")
@onready var flash_material = preload("res://Shaders/Flash.tres")

var spawner:Spawner

var original_pos: Vector2
var original_rotation: float

class TimePosition:  
	var pos: Vector2
	var rot: float

var positions : Array
var time 



func _ready():
	material = flash_material
	
	for i in get_children():
		if i.get("use_parent_material") != null:
			i.use_parent_material = true
	
	original_pos = position
	original_rotation = rotation
	
	spawner = Spawner.new()
	spawner.auto_parent = true
	self.add_child(spawner)
	
	TimeManager.connect("time_changed", _on_time_changed)
	#TimeManager.connect("looped", _on_loop)
	
	

func _on_time_changed():
	if TimeManager.is_approaching_loop():
		var difference = TimeManager.get_distance_from_loop_point()
		material.set_shader_parameter("flash_modifier", 1 - (difference / TimeManager.LOOPAPPROACHPOINT))
	else:
		material.set_shader_parameter("flash_modifier", 0)
		

#func _on_loop():
	#spawner.spawn_object(sparkle)
	#
	##make objects in teleport list do their teleport effect
	#await moved
	#spawner.spawn_object()
	#print("on loop")

func _teleport(prev_pos):
	await get_tree().process_frame
	#var movement = prev_pos - global_position
	emit_signal("moved")

func _create_teleport_effect():
	spawner.spawn_object()
