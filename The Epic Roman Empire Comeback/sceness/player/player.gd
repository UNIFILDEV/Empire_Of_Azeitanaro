extends CharacterBody2D

@export var speed: float = 250.0
@export var acceleration: float = 800.0
@export var friction: float = 800
@export var jump_velocity: float = -350.0
@export var gravity: float = 800.0

@export var walk_speed: float = 100.0

@export var dash_speed: float = 800.0  # Velocidade do dash
@export var dash_duration: float = 0.2  # Duração do dash
@export var dash_cooldown: float = 0.5  # Tempo entre o dash

@onready var sprite = $AnimatedSprite

var attacking = false
var air_control_factor: float = 0.5
var original_gravity: float = gravity
var attack_type = ""
var is_dashing: bool = false
var dash_timer: float = 0.0

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
				velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
				sprite.flip_h = direction < 0
		else:
			velocity.x = 0
		move_and_slide()
		return

	if (Input.is_action_just_pressed("jump")) and is_on_floor():
		velocity.y = jump_velocity

	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction = 1

	var current_speed = speed
	if Input.is_action_pressed("walking"):
		current_speed = walk_speed

	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * current_speed, acceleration * delta)
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

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

func _input(event : InputEvent):
	if(event.is_action_pressed("ui_down") and is_on_floor()):
		position.y += 1	
