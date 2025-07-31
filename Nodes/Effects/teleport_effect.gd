extends Node2D

func _ready() -> void:
	$CPUParticles2D.emitting = true
	$AnimatedSprite2D.play("teleport")
	await $CPUParticles2D.finished
	queue_free()
