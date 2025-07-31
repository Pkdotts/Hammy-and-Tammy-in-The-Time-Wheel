extends Node2D

func _ready() -> void:
	await get_tree().process_frame
	$CPUParticles2D.emitting = true
	$AnimatedSprite2D.play("teleport")
	await $CPUParticles2D.finished
	queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.hide()
