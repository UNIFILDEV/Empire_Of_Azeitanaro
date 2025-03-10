extends CharacterBody2D

@export var speed: float = 100.0
@export var acceleration: float = 2000.0
@export var friction: float = 2400.0
@export var jump_velocity: float = -250.0
@export var gravity: float = 800.0

@onready var sprite = $AnimatedSprite
@onready var attack_timer = $AttackTimer
@onready var camera = $Camera2D
@onready var collision_shape = $CollisionShape2D

var attacking = false  # Flag para saber se o jogador está atacando
var damage: int = 1
var life: int = 2

# Função de física
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)

	# Verifica se há colisão e se o jogador está atacando
	if collision and attacking:
		var collider = collision.get_collider()  # Acessa o corpo com o qual o jogador colidiu
		if collider.is_in_group("enemies"):  # Verifica se o corpo colidido é um inimigo
			print('player deu dano')
			collider.take_damage(damage)  # Aplica o dano ao inimigo
	
	# Colisão do jogador com inimigos (toma dano)
	if collision and collision.get_collider().is_in_group("enemies"):
		print('Player recebeu dano')
		life -= 1  # Reduz a vida do jogador
		if life <= 0:
			print('Player morreu')
			queue_free()  # Remove o jogador da cena

	# Gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# Comandos de pulo
	if Input.is_action_just_pressed("jump") and is_on_floor():
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
	
	# Verifica se o jogador está atacando
	check_attack()
	update_animation()

	move_and_slide()

# Verifica se o jogador está tentando atacar
func check_attack():
	if Input.is_action_just_pressed("attack_1"):
		start_attack("attack_1")
	elif Input.is_action_just_pressed("attack_2"):
		start_attack("attack_2")

# Função que inicia o ataque
func start_attack(attack_type):
	attacking = true
	sprite.play(attack_type)
	attack_timer.start()

# Reseta o estado de ataque após o tempo do ataque
func _on_AttackTimer_timeout():
	attacking = false

# Atualiza a animação do jogador
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
