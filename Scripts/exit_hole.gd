extends Sprite2D

@export var backwards_door := false
@export_file("*.tscn") var map: String
var active = true

func _ready() -> void:
	active = (Global.got_cheese == backwards_door)


func _process(delta: float) -> void:
	if Global.current_hammy.in_front_of_door and active:
		if Input.is_action_just_pressed("ui_accept"):
			change_scenes()

func change_scenes():
	Global.current_hammy.pause()
	UiCanvasLayer.circle_transition()
	await UiCanvasLayer.transition.transition_finished
	get_tree().change_scene_to_file(map)
	Global.current_hammy.unpause()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == Global.current_hammy:
		Global.current_hammy.in_front_of_door = true
		$Label.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == Global.current_hammy:
		Global.current_hammy.in_front_of_door = false
		$Label.visible = false
