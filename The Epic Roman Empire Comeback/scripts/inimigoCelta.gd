extends CharacterBody2D

const SPEED = 50.0
const INCREASED_SPEED = 70.0
const JUMP_VELOCITY = -400.0
const JUMP_DELAY = 1
const PATROL_DELAY = 0.1

var direction := -1
var patrol_distance: float = 100.0
var starting_position: Vector2

var isMovingRight = true

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite = $AnimatedSprite
@onready var detection_area: Area2D = $DetectionPatrolZone
@onready var collision: CollisionShape2D = $CollisionBody
@onready var player: Node2D = null
@onready var timer = $Timer

var life: int = 2
var is_following_player: bool = false
var jump_timer: float = 0.0
var patrol_timer: float = 0.0

func _ready():
	load_player()
	starting_position = global_position
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	detect_turn_around()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		is_following_player = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		is_following_player = false
		reset_patrol()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_wall() and jump_timer <= 0:
		jump()

	# Verifique se o player é válido antes de acessar a posição dele
	if is_instance_valid(player) and abs(global_position.x - player.global_position.x) < 10:
		patrol_timer = PATROL_DELAY

	if patrol_timer > 0:
		patrol_timer -= delta
		patrol()
	elif is_following_player and is_instance_valid(player):
		follow_player()
	else:
		patrol()
	
	if velocity.x != 0:
		sprite.play("walk")
	else:
		sprite.stop()

	move_and_slide()

	# Verifique se a posição de patrulha excedeu o limite
	if abs(global_position.x - starting_position.x) >= patrol_distance and not is_following_player:
		direction *= -1

	sprite.scale.x = direction
	collision.position.x = abs(collision.position.x) * direction * -1

	if jump_timer > 0:
		jump_timer -= delta

func follow_player():
	# Verifique se o player é válido antes de seguir
	if is_instance_valid(player):
		var direction_to_player = player.global_position.x - global_position.x
		velocity.x = sign(direction_to_player) * INCREASED_SPEED

		if direction_to_player != 0:
			direction = sign(direction_to_player)

func patrol():
	velocity.x = direction * SPEED

func jump():
	velocity.y = JUMP_VELOCITY
	jump_timer = JUMP_DELAY

func take_damage(amount: int):
	life -= amount
	print('Monstro tomou dano da espada')

	if life <= 0:
		queue_free()
		print('Monstro morreu')

func reset_patrol():
	starting_position = global_position
	direction = -1
	velocity.x = 0
	sprite.scale.x = direction

func detect_turn_around():
	if not $RayCast2D.is_colliding() and is_on_floor():
		isMovingRight = !isMovingRight
		scale.x = -scale.x

func hit():
	$HurtPlayerZone.monitoring = true

func endHit():
	$HurtPlayerZone.monitoring = false

func startWalk():
	$AnimatedSprite.play("walk")


func _on_hurt_player_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		$AnimatedSprite.play("attack")

func _on_detection_zone_body_entered(body):
	timer.start()
	body.get_node("CollisionBody").queue_free()
	Engine.time_scale = 0.8

func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func load_player():
	# Espera 1 frame para garantir que o player foi criado
	await get_tree().process_frame
	var players = get_tree().get_nodes_in_group("player")
	player = players[0]  # Armazena o player na variável
