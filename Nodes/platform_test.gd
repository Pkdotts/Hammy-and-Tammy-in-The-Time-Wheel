extends AbstractPlatform
class_name AnimatedPlatform

@export var check = false
@export var can_teleport = true

var teleport_list: Array
var prev_pos

func _ready():
	super._ready()
	
	if get_node("Teleporter") != null:
		prev_pos = $Teleporter.global_position
	
	


func _physics_process(delta: float) -> void:
	if get_node("Teleporter") != null:
		if prev_pos != $Teleporter.global_position:
			if check:
				print("previous" + str(prev_pos))
				print("current" + str($Teleporter.global_position))
			_teleport(prev_pos)
		
		
		prev_pos = $Teleporter.global_position
	
#func _on_time_changed():
	#var time = TimeManager.get_current_time()/360
	
	
#overrides
func _on_loop(): 
	spawner.spawn_object(sparkle)
	
	#make objects in teleport list do their teleport effect
	for i in teleport_list:
		if i.has_method("create_teleport_effect"):
			i.create_teleport_effect()
	await moved
	spawner.spawn_object()
	for i in teleport_list:
		if i.has_method("create_teleport_effect"):
			i.create_teleport_effect()
	print("on loop")

#overrides
func _teleport(prev_pos):
	await get_tree().process_frame
	var movement = prev_pos - $Teleporter.global_position
	
	for i in teleport_list:
		i.global_position -= movement
		
		print(movement)
	
	emit_signal("moved")


	
	

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
