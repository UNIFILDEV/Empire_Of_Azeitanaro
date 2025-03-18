class_name Player extends CharacterBody2D

signal vidaMudou
signal energiaMudou

@export var speed: float = 250.0
@export var jump_speed: float = -370.0
@export var walk_speed: float = 80.0
@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var dash_speed: float = 600.0  # Velocidade do dash
@export var dash_duration: float = 0.1  # Duração do dash
@export var dash_cooldown: float = 0.5  # Tempo entre o dash

@export var vidaMax = 100
@export var vidaAtual = 60

@export var energiaMax = 100
@export var energiaAtual = 100

@onready var sprite = $AnimatedSprite
@onready var collision = $CollisionBody

var attacking = false
var original_gravity: float = gravity
var attack_type = ""
var is_dashing: bool = false
var dash_timer: float = 0.0

func _ready():
	set_deferred("monitoring", true)
	EventController.connect("healed", onHealed)

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
				collision.position.x = abs(collision.position.x) * (1 if sprite.flip_h else -1)
		else:
			velocity.x = 0
		move_and_slide()
		return

	if (Input.is_action_pressed("jump")) and is_on_floor():
		velocity.y = jump_speed

	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction = 1

	var current_speed = speed
	if Input.is_action_pressed("walking"):
		current_speed = walk_speed

	if direction != 0:
		velocity.x = direction * current_speed
		sprite.flip_h = direction < 0
		collision.position.x = abs(collision.position.x) * (1 if sprite.flip_h else -1)
	else:
		velocity.x = 0

	check_attack()
	update_animation()

	move_and_slide()

func update_animation():
	if attacking:
		return

	if is_on_floor():
		if velocity.x == 0:
			sprite.play("idle")
		elif abs(velocity.x) > speed * 0.5:
			sprite.play("run")
		else:
			sprite.play("walk")
	else:
		if velocity.y < 0:
			sprite.play("jump")
		else:
			sprite.play("fall")

func check_attack():
	if Input.is_action_just_pressed("attack_3") and dash_timer <= 0:
		if velocity.x == 0:  # Se o player estiver parado
			start_attack("attack_3")  # Realiza o ataque sem o dash
		else:  # Se o player estiver em movimento
			start_attack("attack_3")  # Realiza o ataque com dash
			start_dash()

	elif Input.is_action_just_pressed("attack_1"):
		start_attack("attack_1")
	elif Input.is_action_just_pressed("attack_2"):
		start_attack("attack_2")

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
	# Aplica a direção do dash
	if Input.is_action_pressed("ui_left"):
		velocity.x = -dash_speed  # Dash para a esquerda
		sprite.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		velocity.x = dash_speed  # Dash para a direita
		sprite.flip_h = false

func _on_animated_sprite_finished():
	attacking = false
	attack_type = ""
	gravity = original_gravity

func hurtByEnemy():
	vidaAtual -= 10
	if vidaAtual < 0:
		vidaAtual = vidaMax
	
	vidaMudou.emit()

func onHealed(valor: int):
	vidaAtual = min(vidaAtual + valor, vidaMax)

func _input(event : InputEvent):
	if(event.is_action_pressed("ui_down") and is_on_floor()):
		position.y += 1	
