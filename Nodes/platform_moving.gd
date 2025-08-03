extends AbstractPlatform
class_name AnimatedPlatform

@export var check := false
@export var can_teleport := true

var teleported_object: Player = null
var prev_pos: Vector2

func _ready():
	super._ready()
	
	if get_node("Teleporter") != null:
		prev_pos = $Teleporter.global_position
		$Teleporter.connect("area_entered", _on_teleporter_area_entered)
		$Teleporter.connect("area_exited", _on_teleporter_area_exited)
	
	


func _physics_process(_delta: float) -> void:
	if get_node("Teleporter") != null:
		if prev_pos != $Teleporter.global_position and !TimeManager.is_approaching_loop():
			if check:
				print("previous" + str(prev_pos))
				print("current" + str($Teleporter.global_position))
			_teleport(prev_pos)
		
		
		prev_pos = $Teleporter.global_position
	
#func _on_time_changed():
	#var time = TimeManager.get_current_time()/360
	
	
#overrides
#func _on_loop(): 
	#spawner.spawn_object(sparkle)
	#
	##make objects in teleport list do their teleport effect
	##for i in teleport_list:
		##if i.has_method("create_teleport_effect"):
			##i.create_teleport_effect()
	#await moved
	#spawner.spawn_object()
	##for i in teleport_list:
		##if i.has_method("create_teleport_effect"):
			##i.create_teleport_effect()
	#print("on loop")

#overrides
func _teleport(pos: Vector2):
	if teleported_object != null and (teleported_object.is_on_floor() or teleported_object.is_on_wall()) and teleported_object.visible:
		await get_tree().process_frame
		var movement = pos - $Teleporter.global_position
		
		teleported_object.global_position -= movement
		
		print(movement)

		emit_signal("moved")

func _on_teleporter_area_entered(area: Area2D) -> void:
	if area.get_groups().has("Teleportable"):
		teleported_object = area.get_parent()
		print("entered")


func _on_teleporter_area_exited(area: Area2D) -> void:
	if area.get_groups().has("Teleportable"):
		teleported_object = null
		print("exited")
