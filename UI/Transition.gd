extends Control
class_name Transition

signal transition_finished

@onready var anim_player = $AnimationPlayer

func _ready() -> void:
	hide()

func circlein():
	anim_player.play("circlein")
	show()
	
func circleout():
	anim_player.play("circleout")
	show()


func _on_animation_player_animation_finished(_anim_name):
	transition_finished.emit()
