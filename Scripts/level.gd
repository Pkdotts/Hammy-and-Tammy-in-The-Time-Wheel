class_name Level extends Node2D

@export var _level_number: int = 1
@export var _music_name: String = ""

@export var _normal_spawn_point: Node
@export var _reverted_spawn_point: Node

func _ready() -> void:
	if UiCanvasLayer.tammy == null:
		UiCanvasLayer.add_tammy_ui()

	AudioManager.play_music(_music_name)

func get_level_number() -> int:
	return _level_number

func get_spawn_position() -> Vector2:
	var node := _normal_spawn_point if not Global.got_cheese else _reverted_spawn_point
	return node.global_position if node else Vector2.ZERO

func end_level():
	UiCanvasLayer.circle_transition()
	await UiCanvasLayer.transition.transition_finished
	Global.goto_level(_level_number - 1 if Global.got_cheese else _level_number + 1)
