extends Area2D

signal done
signal entered
signal moved_player

@export var targetX = 0
@export var targetY = 0
@export var dir = Vector2.ZERO
@export var sound = ""
@export var end_sound = ""
@export_enum("Fade", "Circle", "Circle Focus", "Circle Pop", "Cut") var transit_in_anim = "Fade"
@export_enum("Fade", "Circle", "Circle Focus", "Circle Pop", "Cut") var transit_out_anim = "Fade"
@export var transit_in_color = Color.BLACK
@export var transit_out_color = Color.BLACK
@export var fade_in_speed = 1.0
@export var fade_out_speed = 1.0
@export var fadeout_music_on_scene_change = true
@export var fadeout_music_length = 0.8
@export var targetScene = ""
@export var set_respawn = false
@export var set_crumbs = false
@export var unpause_player = true
@export var flag_set := ""
@export var set_flag_state := true

var fade_done = false
var currentState = 0
var player = null
var sameScene = false
var activeDoor = true
var fade = null

@onready var newpos = $Position2D


func _ready():
	set_process(false)

func _on_Door_body_entered(body):
	if body == Global.currentHammy:
		Global.currentHammy.pause()
		await get_tree().process_frame
		enter(body)

func _process(_delta):
	if currentState != 0:
		match currentState:
			1:
				if fade_done:
					currentState = 2
			2:
				emit_signal("entered")
				Global.currentHammy.camera.current = true
				Global.currentHammy.visible = true
				fade.colorRect.material.set_shader_param("cut", 0)
				if !sameScene:
					_change_scene()
					#_move_player()
					
				else :
					_goto()
				if dir != Vector2.ZERO:
					player.animationTree.active = true
					player.direction = dir
					player.inputVector = dir
					player.blend_position(dir)
					player.animationState.travel("Idle")
					
				
				currentState = 3
			3:
				fade_out()
				if end_sound != null and end_sound != "":
					$AudioStreamPlayer.stream = load("res://Audio/Sound effects/" + end_sound)
					$AudioStreamPlayer.play()
				currentState = 4
			4:
				if fade_done:
					set_process(false)
						#if set_crumbs and InventoryManager.crumbTrail.scene != "":
						#	InventoryManager.setCrumbs(global.currentScene.filename, player.global_position)
					player.unpause()
					if !sameScene:
						Global.remove_persistent(self)
						queue_free()
					else:
						activeDoor = true
						currentState = 0
					if set_respawn:
						Global.set_respawn()
					emit_signal("done")

func _change_scene():
	Global.goto_scene("res://Maps/" + targetScene + ".tscn", Vector2(targetX, targetY - 7))
	var cam = Global.currentHammy.get_node("Camera2D")
	#cam.limit_top = -10000000
	#cam.limit_left = -10000000
	#cam.limit_right = 10000000
	#cam.limit_bottom = 10000000
	cam.smoothing_enabled = false

func _move_player():
	player.global_position.x = targetX
	player.global_position.y = targetY - 7
	emit_signal("moved_player")
	await get_tree().process_frame
	

func _goto():
	#var cam = Global.persistPlayer.get_node("Camera2D")
	player.global_position.x = newpos.global_position.x
	player.global_position.y = newpos.global_position.y - 7
	emit_signal("moved_player")
	#cam.limit_top = -10000000
	#cam.limit_left = -10000000
	#cam.limit_right = 10000000
	#cam.limit_bottom = 10000000
	#cam.smoothing_enabled = false

func fade_in():
	fade_done = false
	fade.fade_in(transit_in_anim, transit_in_color, fade_in_speed)
	await fade.fade_in_done
	fade_done = true

func fade_out():
	fade_done = false
	if transit_out_anim == "":
		transit_out_anim = transit_in_anim
	fade.fade_out(transit_out_anim, transit_out_color, fade_out_speed)
	await fade.fade_out_mostly_done
	fade_done = true

func enter(_player=Global.currentHammy):
	player = _player
	#if !global.cutscene:
	#set_flag()
	#fade = uiManager.fade
	if activeDoor:
		if Global.currentScene.get_name() == targetScene or targetScene == "":
			sameScene = true
		else:
			if fadeout_music_on_scene_change:
				for musicChanger in AudioManager.musicChangers:
					musicChanger.stop_music(fadeout_music_length)
			Global.add_persistent(self)
		activeDoor = false
		if sound != null and sound != "":
			$AudioStreamPlayer.stream = load("res://Audio/Sound effects/" + sound)
			$AudioStreamPlayer.play()
		Global.currentHammy.pause()
		fade_in()
		currentState = 1
		set_process(true)

#func set_flag():
#	if flag_set != "":
#		if globaldata.flags.has(flag_set):
#			globaldata.flags[flag_set] = set_flag_state
