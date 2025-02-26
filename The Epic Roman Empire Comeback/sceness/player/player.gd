extends CharacterBody2D

@export var speed: float = 250.0
@export var acceleration: float = 800.0
@export var friction: float = 2400.0
@export var jump_velocity: float = -300.0
@export var gravity: float = 800.0

@onready var sprite = $AnimatedSprite
@onready var attack_timer = $AttackTimer

var attacking = false  # Flag para saber se o jogador está atacando

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	# Se estiver atacando, não permite movimentação
	if attacking:
		move_and_slide()
		return

	# Comandos de pulo
	if (Input.is_action_just_pressed("jump")) and is_on_floor():
		velocity.y = jump_velocity

	# Movimento lateral
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction = 1

	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		sprite.flip_h = direction < 0  # Espelha o sprite corretamente
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	check_attack()
	update_animation()

	move_and_slide()

func check_attack():
	if Input.is_action_just_pressed("attack_1"):
		start_attack("attack_1")
	elif Input.is_action_just_pressed("attack_2"):
		start_attack("attack_2")

func start_attack(attack_type):
	attacking = true
	sprite.play(attack_type)
	attack_timer.start()

func _on_AttackTimer_timeout():
	attacking = false

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
