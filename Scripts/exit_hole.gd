extends Sprite2D

var active := false

func enter():
	$Door.enter()

func _input(event):
	if active:
		if event.is_action_pressed("ui_space"):
			enter()


func _on_door_body_entered(body) -> void:
	print("se entrasdkjñfjdaskl")
	if body == Global.currentHammy:
		print("se activafsf")
		active = true
		$Label.visible = true

func _on_door_body_exited(body) -> void:
	active = false
	$Label.visible = false
