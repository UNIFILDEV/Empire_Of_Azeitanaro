class_name Player extends CharacterBody2D

signal vidaMudou
signal energiaMudou

@export var speed: float = 150.0
@export var jump_speed: float = -370.0
@export var sprint_speed: float = 275.0
@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var dash_speed: float = 600.0
@export var dash_duration: float = 0.1
@export var dash_cooldown: float = 0.5

@export var vidaMax = 100
@export var vidaAtual = 100

@export var energiaMax = 100
@export var energiaAtual = 100
@export var energiaGasto = 10

@onready var sprite = $AnimatedSprite
@onready var collision = $CollisionBody

const soundJump = preload("res://sceness/player/sounds/jump.wav")
const soundWalk = preload("res://sceness/player/sounds/walk.mp3")

var attacking = false
var original_gravity: float = gravity
var attack_type = ""
var is_dashing: bool = false
var dash_timer: float = 0.0
var is_sprinting: bool = false
var jump_sound: AudioStreamPlayer2D
var walk_sound: AudioStreamPlayer2D

func _ready():
	set_deferred("monitoring", true)
	EventController.connect("healed", onHealed)
	_add_child_soundJump()
	_add_child_soundWalk()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			velocity.x = 0
		move_and_slide()
		return

	if attacking:
		if (attack_type != "") and not is_on_floor():
			var direction = 0
			if Input.is_action_pressed("ui_left"):
				direction = -1
			if Input.is_action_pressed("ui_right"):
				direction = 1
			if direction != 0:
				velocity.x = direction * speed
				sprite.flip_h = direction < 0
				if is_instance_valid(collision):
					collision.position.x = abs(collision.position.x) * (1 if sprite.flip_h else -1)
		else:
			velocity.x = 0
		move_and_slide()
		return

	if (Input.is_action_pressed("jump")) and is_on_floor():
		jump_sound.play()
		velocity.y = jump_speed

	if (Input.is_action_just_released("jump")):
		if velocity.y < 0:
			velocity.y = -50

	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction = 1

	var current_speed = speed
	var can_sprint = Input.is_action_pressed("sprint") && energiaAtual > 0
	
	if can_sprint:
		current_speed = sprint_speed
		energiaAtual -= energiaGasto * delta
		is_sprinting = true
		energiaMudou.emit()
	else:
		if energiaAtual < energiaMax:
			energiaAtual += energiaGasto * delta
			energiaMudou.emit()
		is_sprinting = false

	if direction != 0:
		velocity.x = direction * current_speed
		sprite.flip_h = direction < 0
		# Verifique se o 'collision' é válido antes de acessar sua posição
		if is_instance_valid(collision):
			collision.position.x = abs(collision.position.x) * (1 if sprite.flip_h else -1)
		if not walk_sound.playing and is_on_floor():
			walk_sound.play()
	else:
		velocity.x = 0
		if walk_sound.playing:
			walk_sound.stop()
	if not is_on_floor() and walk_sound.playing:
		walk_sound.stop()
		

	check_attack()
	update_animation()

	move_and_slide()

func update_animation():
	if attacking:
		return

	if is_on_floor():
		if velocity.x == 0:
			if sprite.animation != "idle":
				sprite.play("idle")
		elif is_sprinting && energiaAtual > 0:
			if sprite.animation != "run":
				sprite.play("run")
		else:
			sprite.play("walk")
	
	else:
		if velocity.y < 0:
			if sprite.animation != "jump":
				sprite.play("jump")
		else :
			if sprite.animation != "fall":
				sprite.play("fall")

func check_attack():
	if Input.is_action_just_pressed("attack_3") and dash_timer <= 0:
		if velocity.x == 0:  # Se o player estiver parado
			start_attack("attack_3")
		else:
			start_attack("attack_3")
			start_dash()
		print('ataque 3 apertado')

	elif Input.is_action_just_pressed("attack_1"):
		start_attack("attack_1")
		print('ataque 1 apertado')
	elif Input.is_action_just_pressed("attack_2"):
		start_attack("attack_2")
		print('ataque 2 apertado')

func start_attack(type):
	attacking = true
	attack_type = type
	sprite.play(type)

	if type == "attack_1":
		gravity = 1200.0

	if not sprite.animation_finished.is_connected(_on_animated_sprite_finished):
		sprite.animation_finished.connect(_on_animated_sprite_finished)

func start_dash():
	is_dashing = true
	dash_timer = dash_duration
	if Input.is_action_pressed("ui_left"):
		velocity.x = -dash_speed
		sprite.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		velocity.x = dash_speed
		sprite.flip_h = false

func _on_animated_sprite_finished():
	attacking = false
	attack_type = ""
	gravity = original_gravity

func hurtBySpike():
	vidaAtual -= 10
	if vidaAtual < 0:
		vidaAtual = vidaMax
	
	vidaMudou.emit()

func onHealed(valor: int):
	vidaAtual = min(vidaAtual + valor, vidaMax)

func _input(event : InputEvent):
	if(event.is_action_pressed("ui_down") and is_on_floor()):
		position.y += 1

func _add_child_soundJump():
	jump_sound = AudioStreamPlayer2D.new()
	jump_sound.stream = soundJump
	jump_sound.set_volume_db(-25.0)
	add_child(jump_sound)
	
func _add_child_soundWalk():
	walk_sound = AudioStreamPlayer2D.new()
	walk_sound.stream = soundWalk
	#jump_sound.set_volume_db(-25.0)
	add_child(walk_sound)
