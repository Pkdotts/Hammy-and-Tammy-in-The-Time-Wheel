extends Sprite2D



func _on_static_body_2d_body_entered(body: Node2D) -> void:
	if body is Player and !Global.got_cheese:
		Global.got_cheese = true
		AudioManager.play_sfx("cheese")
		$AnimationPlayer.play("collect")
		await $AnimationPlayer.animation_finished
		queue_free()
