extends Node2D
class_name AbstractPlatform

var original_pos: Vector2
var original_rotation: float

func _ready():
	original_pos = position
	original_rotation = rotation
