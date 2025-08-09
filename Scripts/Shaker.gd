extends Node
class_name Shaker

#Used for shaking a Vector2 attribute


var timer = 0
var shakes_left: float


var shake_interval: float # The time between movements during the shake
var shake_magnitude: float # The amount of movement in a shake
var shake_magnitude_reduction: float = 0.0 # The amount the shake is reduced after each movement
var shake_direction : Vector2 # The direction to shake in
var shake_side = 1 # Flips between -1 and 1 to determine the position
var shake_side_amplitude : Vector2 # x determines the multiplier when shake_side = -1, y determines the multiplier when shake_side = 1
#var old_offset = Vector2.ZERO # The original offset of the property
#var ignore_timescale = false

var shaked_object = null
var shaked_property = ""

signal finished_shake

# The shake's constructor
func _init(object : Node2D, property : String , direction := Vector2.ONE, magnitude := 1.0, time := 1.0, interval := 0.2, side_amplitude := Vector2.ONE, diminish := true) -> void:
	shaked_object = object
	#old_offset = object.offset
	shaked_property = property
	shake_direction = direction
	shake_side_amplitude = side_amplitude
	shake_magnitude = magnitude
	if diminish:
		shake_magnitude_reduction = magnitude * interval
	shake_interval = interval
	#ignore_timescale = ignore_time
	shakes_left = int(time / interval)
	object.add_child(self)


func _physics_process(delta: float) -> void:
	if shakes_left > 0:
		timer += delta
		if timer >= shake_interval:
			shakes_left -= 1
			shake_side = shake_side * -1
			timer -= shake_interval
			var new_side = shake_side
			
			if new_side == 1:
				new_side *= shake_side_amplitude.y
			else:
				new_side *= shake_side_amplitude.x
			
			# Make it so if the shake magnitude is less than a pixel, 
			# it sets the magnitude to either 0 or 1
			var new_magnitude = max(shake_magnitude, 1.0)
			if shake_magnitude <= 0.5 and shake_side == -1:
				new_magnitude = 0
			
			var offsetting:Vector2
			var dir = shake_direction
			if shake_direction != Vector2.ZERO:
				offsetting = Vector2(new_side, new_side)
			else:
				offsetting = Vector2(1, 1)
				dir = Vector2(randf_range(-1, 1), randf_range(-1, 1))
			var new_offset = offsetting * dir * new_magnitude
			
			
			
			if shake_magnitude <= 0.5 or shake_interval < 0.5:
				shaked_object.set(shaked_property, new_offset)
			else:
				var tween = shaked_object.get_tree().create_tween()
				tween.tween_property(shaked_object, shaked_property, new_offset, shake_interval)
			print("SHAKING", shaked_object.get(shaked_property))
			
			shake_magnitude -= shake_magnitude_reduction
	else:
		stop()

func stop():
	shaked_object = null
	queue_free()
	emit_signal("finished_shake")
