extends Node2D

func _ready() -> void:
	$AnimatedSprite2D.play("blood")
	await $AnimatedSprite2D.animation_finished
	queue_free()
	
