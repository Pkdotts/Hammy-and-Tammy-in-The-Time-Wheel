extends AnimationPlayer
class_name TimeAnimationPlayer

@export var startingAnim = ""

func _ready() -> void:
	play(startingAnim)

func _process(delta: float) -> void:
	seek(TimeManager.get_point_in_time(current_animation_length), true)
