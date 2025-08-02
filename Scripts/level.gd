extends Node2D

func _ready() -> void:
	if UiCanvasLayer.tammy == null:
		UiCanvasLayer.add_tammy_ui()
