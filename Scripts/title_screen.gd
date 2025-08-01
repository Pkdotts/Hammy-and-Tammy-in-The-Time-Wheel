extends Control

const CREDITS_STEPS = 3

@onready var animationPlayer = $CanvasLayer/AnimationPlayer
@onready var label = $CanvasLayer/Aboveground/Base/IntroTexts/Label
@onready var arrow = $arrow
var active = false
var canSkip = false
var seq = ""
var tween = create_tween()
var soundEffects = {
}


func _ready():
	arrow.on = true
	#Global.currentHammy.pause()
	_show_menu()
	# LOCALIZATION Use of csv key for "Originally Produced by"
	#if AudioManager.get_audio_player(AudioManager.get_latest_audio_player_index()).stream != load("res://Audio/Music/Mother Earth.mp3"):
	#	AudioManager.fadeout_all_music(0.2)
	#	AudioManager.add_audio_player()
	#	AudioManager.play_music_on_latest_player("", "Mother Earth.mp3")
	#	animationPlayer.play("intro1")
	#	canSkip = true
	#else:
	#	animationPlayer.play("Instant Start")
		
	_update_text()
	#Global.connect("locale_changed", _update_text)
	#Global.connect("inputs_changed", _update_text)
#	set_physics_process(false)
#	yield(get_tree(), "idle_frame")
#	set_physics_process(true)

func _update_text():
	pass
	#var pressText = "[center]%s[/center]" % TextTools.replace_text("MENU_PRESS")
	#$CanvasLayer / Title / PressButton.bbcode_text = pressText

	#$CanvasLayer / Title / Version2.text = tr("TITLE_FNKEYS").format([TextTools.get_key_name("ui_fullscreen", Global.KEYBOARD), TextTools.get_key_name("ui_winsize", Global.KEYBOARD)])

func _input(event):
	for action in InputMap.get_actions():
		if Input.is_action_just_pressed(action):
			seq += action.substr(3, 2)
			break
	
	#if event.is_action_pressed("ui_accept"):
	#	if canSkip:
	#		if $CanvasLayer/AnimationPlayer.current_animation != "Fade" and \
	#		   $CanvasLayer/AnimationPlayer.current_animation != "Skip Fade":
	#			$CanvasLayer/AnimationPlayer.play("Skip Fade")
	#	elif $CanvasLayer/Title/PressButton.modulate == Color.WHITE:
			_show_menu()
	#		AudioManager.play_sfx(soundEffects["cursor2"], "cursor")

func _on_OptionsUI_back():
	AudioManager.play_sfx(soundEffects["back"], "cursor")
	active = true

func set_saveFile():
	pass
	#var newSave = 1
	#for num in 10:
	#	if FileAccess.file_exists("user://saveFile" + str(num) + ".save"):
	#		newSave += 1
	#if newSave > 10:
	#	newSave = 10
	#Globaldata.saveFile = newSave

		
	#for i in $VBoxContainer.get_child_count():
		#var flash = $VBoxContainer.get_child(i).get_material()
		#if i == option:
		#	flash.set_shader_param("flash_modifier", 0.35)
		#else:
		#	flash.set_shader_param("flash_modifier", 0)
	
func _on_AnimationPlayer_animation_finished(anim_name):
	for i in range(1, CREDITS_STEPS):
		if anim_name == "intro%s" % i:
			animationPlayer.play("intro%s" % (i + 1))
			label.text = "TITLE_INTRO_%s" % (i + 1)
			var swap_array = tr("TITLE_INTRO_SWAP_LINES").split(",")
			if i < swap_array.size() and swap_array[i]:
				_swap_credit_layout()

	if anim_name == "intro%s" % CREDITS_STEPS:
		$CanvasLayer/Aboveground/Base.hide()
		animationPlayer.play("Fade")

func _swap_credit_layout():
	var container = $CanvasLayer/Aboveground/Base/IntroTexts
	var node_to_move = container.get_child(1)
	container.move_child(node_to_move, 0)

func _show_menu():
	#if Globaldata.saveFile != 0:
	#	option = 1
	#$CanvasLayer/Title/Menu.show()
	#$Tween.interpolate_property($CanvasLayer/Title/PressButton, "modulate",
	#	$CanvasLayer/Title/PressButton.modulate, Color.transparent, 0.2)
	#$Tween.interpolate_property($CanvasLayer/Title/Menu, "modulate",
	#	Color.transparent, Color.white, 0.25,
	#	Tween.TRANS_LINEAR,Tween.EASE_IN_OUT, 0.2)
	#$Tween.start()
	#await tween.finished
	#$CanvasLayer/Title/PressButton.hide()
	active = true
	

func _show_button():
	#$Tween.interpolate_property($CanvasLayer/Aboveground/Base, "modulate",
	#	$CanvasLayer/Aboveground/Base.modulate, Color.transparent, 0.5)
	#$Tween.start()
	#await tween.finished
	#$CanvasLayer/Title/PressButton.show()
	#$Tween.interpolate_property($CanvasLayer/Title/PressButton, "modulate",
	#	Color.transparent, Color.white, 0.5)
	#$Tween.start()
	canSkip = false

func _on_arrow_moved():
	pass


func _on_arrow_selected(cursor_index: Variant) -> void:
	match cursor_index:
		0: # New game?
			$Door.enter()
		1: # Options
			pass
