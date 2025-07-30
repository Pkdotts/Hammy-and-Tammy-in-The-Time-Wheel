extends "res://Scripts/platform.gd"

func _ready():
	super._ready()
	$StaticBody2D/AnimationPlayer.play("new_animation")

func _on_time_changed():
	var time = TimeManager.get_current_time()/360
	$StaticBody2D/AnimationPlayer.seek($StaticBody2D/AnimationPlayer.current_animation_length*time, true)
	
