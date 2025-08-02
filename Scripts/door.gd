extends Area2D

signal done
signal entered
signal moved_player

@export var targetX = 0
@export var targetY = 0
@export var dir = Vector2.ZERO
@export var targetScene = ""
@export var set_respawn = false
@export var unpause_player = true

var fade_done = false
var currentState = 0
var player = null
var sameScene = false
var activeDoor = true

@onready var newpos = $Position2D



func _process(_delta):
	if currentState != 0:
		match currentState:
			1:
				if fade_done:
					currentState = 2
			2:
				emit_signal("entered")
				Global.currentHammy.visible = true
				if !sameScene:
					_change_scene()
					#_move_player()
					
				if dir != Vector2.ZERO:
					player.animationTree.active = true
					player.direction = dir
					player.inputVector = dir
					player.blend_position(dir)
					player.animationState.travel("Idle")
					
				
				currentState = 3
			3:
				fade_out()
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

func fade_in():
	fade_done = false
	UiCanvasLayer.circle_in()
	await UiCanvasLayer.transition.transition_finished
	fade_done = true

func fade_out():
	fade_done = false
	UiCanvasLayer.circle_out()
	await UiCanvasLayer.transition.transition_finished
	fade_done = true

func enter(_player=Global.currentHammy):
	player = _player
	if activeDoor:
		if Global.currentScene.get_name() == targetScene or targetScene == "":
			sameScene = true
		activeDoor = false
		Global.currentHammy.pause()
		fade_in()
		currentState = 1
		set_process(true)
