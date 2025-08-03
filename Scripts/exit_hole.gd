extends Node2D

@export var backwards_door := false
@export var cheese_room := false


func _ready() -> void:
	$Label.modulate.a = 0.0
	$Normal.visible = !cheese_room
	$CheeseRoom.visible = cheese_room

func _is_active():
	return (Global.got_cheese == backwards_door)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if Global.current_hammy.in_front_of_door and _is_active() and !Global.current_hammy._paused:
			AudioManager.play_sfx("door")
			Global.current_hammy.hole()
			await get_tree().create_timer(0.3).timeout
			Global.get_current_level().end_level()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and _is_active():
		body.in_front_of_door = true
		var tween = get_tree().create_tween()
		tween.tween_property($Label, "modulate:a", 1.0, 0.5)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player and _is_active():
		body.in_front_of_door = false
		var tween = get_tree().create_tween()
		tween.tween_property($Label, "modulate:a", 0.0, 0.5)
