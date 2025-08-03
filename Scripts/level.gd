class_name Level extends Node2D

@export var _music_name: String = ""

@export var _normal_spawn_point: Node2D
@export var _reverted_spawn_point: Node2D

var _current_checkpoint: Node2D = null

func _ready() -> void:
	if UiCanvasLayer.tammy_ui == null:
		UiCanvasLayer.add_tammy_ui()

	if _music_name:
		AudioManager.play_music(_music_name)
	else:
		AudioManager.stop_music()

func get_spawn_position(checkpoint: bool = true) -> Vector2:
	var node: Node2D
	if checkpoint and _current_checkpoint:
		node = _current_checkpoint
	elif Global.got_cheese:
		node = _reverted_spawn_point
	else:
		node = _normal_spawn_point
	return node.global_position if node else Vector2.ZERO

func hit_checkpoint(checkpoint: Node2D) -> void:
	_current_checkpoint = checkpoint

func end_level():
	UiCanvasLayer.circle_transition()
	await UiCanvasLayer.transition.transition_finished
	Global.goto_next_level()
