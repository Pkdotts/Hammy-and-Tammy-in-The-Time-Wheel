extends Node2D
class_name AbstractPlatform

signal moved

var original_pos: Vector2
var original_rotation: float

class TimePosition:  
	var pos: Vector2
	var rot: float

var positions : Array
var time 



func _ready():
	original_pos = position
	original_rotation = rotation
	TimeManager.connect("time_changed", _on_time_changed)
	TimeManager.connect("looped", _on_loop)
	
	

func _on_time_changed():
	pass
	

func _on_loop():
	pass
