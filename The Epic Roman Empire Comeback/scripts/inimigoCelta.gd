extends EnemyBase

const INCREASED_SPEED = 70.0
const JUMP_VELOCITY = -400.0
const JUMP_DELAY = 1
const PATROL_DELAY = 0.1

var direction := -1
var patrol_distance: float = 100.0
var starting_position: Vector2

var isMovingRight = true

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
#@onready var sprite = $AnimatedSprite
@onready var detection_area: Area2D = $DetectionPatrolZone
@onready var detection_zone_hitbox: Area2D = $DetectionZone
@onready var collision: CollisionShape2D = $CollisionBody
@onready var player: Node2D = null
#@onready var atkTimer = $AttackTimer

var player_in_detection_zone = false
var player_in_damage_zone = false

var is_following_player: bool = false
var jump_timer: float = 0.0
var patrol_timer: float = 0.0
#var can_attack: bool = true

func _ready():
	#var players_in_group = get_tree().get_nodes_in_group("player")
	##if players_in_group.size > 0:
	#playerTeste = players_in_group[0]
	global_player()
	starting_position = global_position
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)
	#detection_zone_hitbox.body_entered.connect(_on_detection_zone_body_entered)
	#timer.connect("timeout", self._on_timer_timeout)

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
		if player_in_detection_zone:
			velocity.x = 0
		else:
			velocity.x = speed * direction
			sprite.play("walk")

	move_and_slide()

	# Verifique se a posição de patrulha excedeu o limite
	if abs(global_position.x - starting_position.x) >= patrol_distance and not is_following_player:
		direction *= -1

	sprite.scale.x = direction
	collision.position.x = abs(collision.position.x) * direction * -1
	$HurtPlayerZone.position.x = 13 * direction
	$DetectionZone.position.x = 13 * direction
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
	velocity.x = direction * speed

func jump():
	velocity.y = JUMP_VELOCITY
	jump_timer = JUMP_DELAY

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
		player_in_damage_zone = true
		#if can_attack:
		apply_damage_loop(body)

func apply_damage_loop(body: Player) -> void:
	while player_in_damage_zone:
		sprite.play("attack")
		#print("Preparando para causar dano...")
		await get_tree().create_timer(0.1).timeout #parâmetro do delay deve estar de acordo com os fps da animação
		if player_in_damage_zone and is_instance_valid(body) and sprite.frame == 5:
			body.take_damage(damage)
			print("Player tomou dano")
		elif not player_in_damage_zone:  # Sai do loop se o jogador sair da zona
			break
			#can_attack = false
			#atkTimer.start()

func _on_detection_zone_body_entered(body):
	if body is Player:
		player_in_detection_zone = true
		#print("Jogador detectado na DetectionZone")

func global_player():
	if Global.player_instance:
		player = Global.player_instance

func _on_detection_zone_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_detection_zone = false
		#print('saiu')

func _on_hurt_player_zone_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_damage_zone = false
		#print("Saiu da hurtbox")
