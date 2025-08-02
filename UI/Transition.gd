extends Control
class_name Transition

signal transition_finished

@onready var anim_player = $AnimationPlayer



func circlein():
	anim_player.play("circlein")
	
func circleout():
	anim_player.play("circleout")


func _on_animation_player_animation_finished(_anim_name):
	transition_finished.emit()
