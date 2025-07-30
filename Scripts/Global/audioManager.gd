extends Control

var musicVolume = -10

var muteState = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_mute"):
		muteState += 1
		if muteState == 3:
			muteState = 0
		match muteState:
			0:
				AudioServer.set_bus_mute(1, false)
				AudioServer.set_bus_mute(2, false)
			1:
				AudioServer.set_bus_mute(1, true)
				AudioServer.set_bus_mute(2, false)
			2:
				AudioServer.set_bus_mute(1, true)
				AudioServer.set_bus_mute(2, true)

func _ready():
	$AudioPlayers/GameMusic.volume_db = musicVolume
	$AudioPlayers/TitleMusic.volume_db = musicVolume

func play_game_music():
	$AudioPlayers/GameMusic.play()
	stop_title_music()

func stop_game_music():
	$AudioPlayers/GameMusic.stop()

func play_title_music():
	$AudioPlayers/TitleMusic.play()
	stop_game_music()

func stop_title_music():
	$AudioPlayers/TitleMusic.stop()

func set_audio_pitch(speed):
	for soundEffect in $Sfx.get_children():
		soundEffect.pitch_scale = speed

func set_sfx_pitch(sfx_name, pitch):
	var sfx_node: AudioStreamPlayer = get_sfx(sfx_name)
	if sfx_node:
		sfx_node.pitch_scale = pitch

func add_sfx(stream, sfx_name) -> AudioStreamPlayer:
	var sfx_node: AudioStreamPlayer = get_sfx(sfx_name)
	if !sfx_node:
		sfx_node = AudioStreamPlayer.new()
		sfx_node.bus = "SFX"
		sfx_node.name = sfx_name
		$Sfx.add_child(sfx_node)
		sfx_node.finished.connect(sfx_node.queue_free)
	sfx_node.stream = stream
	return sfx_node

func get_number_of_sfx() -> int:
	return $Sfx.get_child_count()

func play_sfx(stream, sfx_name):
	var sfx_node: AudioStreamPlayer = add_sfx(stream, sfx_name)
	sfx_node.play()
	#return sfx_node

func get_sfx(sfx_name) -> AudioStreamPlayer:
	return $Sfx.get_node_or_null(sfx_name) as AudioStreamPlayer
