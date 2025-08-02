extends Sprite2D

@export var backwards_door := false
@export_file("*.tscn") var map: String
var active = true
var in_front_of_door = false

func _ready() -> void:
	active = (Global.gotCheese == backwards_door)


func _process(delta: float) -> void:
	if in_front_of_door and active:
		if Input.is_action_just_pressed("ui_accept"):
			change_scenes()

func change_scenes():
	UiCanvasLayer.circle_transition()
	await UiCanvasLayer.transition.transition_finished
	get_tree().change_scene_to_file(map)


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("se entrasdkjñfjdaskl")
	if body == Global.currentHammy:
		print("se activafsf")
		in_front_of_door = true
		$Label.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == Global.currentHammy:
		in_front_of_door = false
		$Label.visible = false
