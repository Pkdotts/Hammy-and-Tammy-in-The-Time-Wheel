extends Sprite2D


func _ready() -> void:
	if Global.got_cheese:
		$AnimatedSprite2D.play("beam_rev")
		$AnimatedSprite2D.show()
	else:
		$AnimatedSprite2D.hide()
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == Global.current_hammy and Global.got_cheese and !Global.current_hammy._paused:
		Global.current_hammy.pause()
		var tween = create_tween()
		tween.tween_property(Global.current_hammy, "global_position", $Node2D.global_position, 0.5)
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_QUART)
		tween.play()
		
		
		await get_tree().create_timer(1).timeout
		UiCanvasLayer.circle_transition()
		await UiCanvasLayer.transition.transition_finished
		Global.change_scenes("EndScreen")
