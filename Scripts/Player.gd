extends CharacterBody2D


signal player_respawn

@onready var animation_player = $AnimationPlayer
@onready var attack_timer = $AttackTimer
@onready var bufferTimer = $BufferJumpTimer
@onready var coyoteTimer = $CoyoteTimer
@onready var raycast1 = $RayCast2D
@onready var raycast2 = $RayCast2D2
@onready var sfxPlayer = $SoundEffectPlayer2D



const RUN_SPEED = 100.0
const ATTACK_SPEED = 200.0
const SLIDEJUMP_SPEED = 300.0
const REG_JUMP_VEL = -250.0
const SLIDE_JUMP_VEL = -200.0
const REGULAR_GRAVITY = 800
const SLIDEJUMP_GRAVITY = 600
enum states {MOVING, JUMPING, DUCKING, ATTACKING, SLIDING, SLIDEJUMP}

var sfx = {
	"jump": "res://Audio/SFX/jump.mp3",
	"attack": "res://Audio/SFX/attack.mp3",
	"slide": "res://Audio/SFX/slide.mp3",
	"dead": "res://Audio/SFX/dead.mp3",
	"duck": "res://Audio/SFX/duck.wav",
	"die": "res://Audio/SFX/dead.mp3"
}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = REGULAR_GRAVITY
var state = states.MOVING
var direction = 1
var speed = RUN_SPEED
var jumpVelocity = REG_JUMP_VEL
var wasOnFloor = true
var active = true
var underCeiling = false
var bufferUnslide = false

var respawnPoint = Vector2.ZERO

func _ready():
	Global.persistPlayer = null
	Global.persistPlayer = self
	attack_timer.timeout.connect(finish_attack)
	switch_state(states.MOVING, "Walk", RUN_SPEED)
	respawnPoint = global_position

func _physics_process(delta):
	if active:
		
		if not is_on_floor():
			velocity.y += gravity * delta
			wasOnFloor = false
		# Handle jump.
		elif attack_timer.time_left == 0 and state != states.MOVING and !wasOnFloor:
			if !bufferUnslide:
				switch_state(states.MOVING, "Walk", RUN_SPEED)
			wasOnFloor = true
		
		if wasOnFloor and bufferUnslide and !raycast1.is_colliding() and !raycast2.is_colliding():
			switch_state(states.MOVING, "Walk", RUN_SPEED)
			bufferUnslide = false
		
		if is_on_floor():
			coyoteTimer.start()
			if bufferTimer.time_left != 0:
				jump()
		
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
		move_and_slide()

func jump():
	if active:
		if is_on_floor() or coyoteTimer.time_left != 0:
			if state == states.SLIDING:
				#SLIDE JUMP
				jumpVelocity = SLIDE_JUMP_VEL
				gravity = SLIDEJUMP_GRAVITY
				state = states.SLIDEJUMP
				
			else:
				#REGULAR JUMP
				jumpVelocity = REG_JUMP_VEL
				gravity = REGULAR_GRAVITY
				if state != states.ATTACKING:
					animation_player.play("Jump")
					play_sound_effect(sfx["jump"])
				
				state = states.JUMPING
			coyoteTimer.stop()
			velocity.y = jumpVelocity
			play_sound_effect(sfx["jump"])
			move_and_slide()
			
		else:
			bufferTimer.start()
			

func duck():
	if active and is_on_floor():
		if state != states.ATTACKING and state != states.SLIDING and state != states.DUCKING:
			play_sound_effect(sfx["duck"])
			switch_state(states.DUCKING, "Duck", RUN_SPEED)
			attack_timer.start()
		elif state == states.ATTACKING:
			#SLIDE
			switch_state(states.SLIDING, "Slide", ATTACK_SPEED)
			attack_timer.start()

func attack():
	if active:
		if state != states.ATTACKING and state != states.SLIDING and state != states.DUCKING:
			play_sound_effect(sfx["attack"], 0)
			switch_state(states.ATTACKING, "Attack", ATTACK_SPEED)
			attack_timer.start()

func finish_attack():
	if active:
		if state != states.SLIDEJUMP:
			if (state == states.DUCKING or state == states.SLIDING):
				if raycast1.is_colliding() or raycast2.is_colliding():
					bufferUnslide = true
				else:
					if !is_on_floor():
						switch_state(states.JUMPING, "Jump", RUN_SPEED)
					else:
						switch_state(states.MOVING, "Walk", RUN_SPEED)
			else:
				if !is_on_floor():
					switch_state(states.JUMPING, "Jump", RUN_SPEED)
				else:
					switch_state(states.MOVING, "Walk", RUN_SPEED)
		else:
			bufferUnslide = true

func switch_state(newState, anim = "", newSpeed = RUN_SPEED):
	speed = newSpeed
	state = newState
	if anim != "":
		animation_player.play(anim)

func die():
	if active:
		play_sound_effect(sfx["die"])
		active = false
		hide()
		UiCanvasLayer.circle_in()
		UiCanvasLayer.close_book()
		await UiCanvasLayer.transition.transition_finished
		return_to_respawn()
		UiCanvasLayer.circle_out()

func set_respawn(point):
	respawnPoint = point

func return_to_respawn():
	show()
	global_position = respawnPoint
	switch_state(states.MOVING, "Walk", RUN_SPEED)
	Global.persistCamera.teleport_to_node()
	active = true
	emit_signal("player_respawn")
	

#func create_dust():
	#var dustParticle = dust.instantiate()
	#dustParticle.global_position = self.global_position
	#get_parent().add_child(dustParticle)
#
#func create_Z():
	#var ZParticle = ZZZ.instantiate()
	#var offset = Vector2(-8, -16)
	#ZParticle.global_position = self.global_position + offset
	#get_parent().add_child(ZParticle)

func play_sound_effect(path, decibel = 8):
	sfxPlayer.volume_db = decibel
	sfxPlayer.stream = load(path)
	sfxPlayer.play()

#func _on_dust_timer_timeout():
	#if is_on_floor() and active:
		#create_dust()
#
#func _on_z_timer_timeout():
	#if active:
		#create_Z()
