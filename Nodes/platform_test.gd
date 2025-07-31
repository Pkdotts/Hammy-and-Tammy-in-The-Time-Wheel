extends AbstractPlatform
class_name AnimatedPlatform

@export var check = false


@export var animationPlayer : AnimationPlayer
@export var animationName := ""

var teleport_list: Array
var prev_pos

func _ready():
	super._ready()
	
	animationPlayer.play(animationName)
	animationPlayer.pause()
	prev_pos = global_position


func _process(delta: float) -> void:
	animationPlayer.seek(TimeManager.get_point_in_time(animationPlayer.current_animation_length), true)
	if check:
		print("previous" + str(prev_pos))
		print("current" + str(global_position))
	if prev_pos != global_position:
		_teleport(prev_pos)
	
	
	prev_pos = global_position
	
#func _on_time_changed():
	#var time = TimeManager.get_current_time()/360
	
	

func _on_loop():
	pass
	
func _teleport(prev_pos):
	await get_tree().process_frame
	var movement = prev_pos - global_position
	#$Spawner.spawn_object()
	for i in teleport_list:
		i.global_position -= movement
		
		print(movement)

func _on_teleporter_body_entered(body: Node2D) -> void:
	if body.get_groups().has("Teleportable"):
		teleport_list.push_front(body)
		print("entered")


func _on_teleporter_body_exited(body: Node2D) -> void:
	if body.get_groups().has("Teleportable"):
		teleport_list.erase(body)
		print("exited")


func _on_teleporter_area_entered(area: Area2D) -> void:
	if area.get_groups().has("Teleportable"):
		teleport_list.push_front(area.get_parent())
		print("entered")


func _on_teleporter_area_exited(area: Area2D) -> void:
	if area.get_groups().has("Teleportable"):
		teleport_list.erase(area.get_parent())
		print("exited")
