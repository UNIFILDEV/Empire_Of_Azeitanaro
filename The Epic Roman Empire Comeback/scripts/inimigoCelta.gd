extends CharacterBody2D

const SPEED = 30.0
const INCREASED_SPEED = 70.0
const JUMP_VELOCITY = -400.0
const JUMP_DELAY = 1
const PATROL_DELAY = 0.1

var direction := -1
var patrol_distance: float = 100.0
var starting_position: Vector2

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite = $AnimatedSprite
@onready var detection_area = $Area2D
@onready var player = get_parent().get_node("Player")

var life: int = 2
var is_following_player: bool = false
var jump_timer: float = 0.0
var patrol_timer: float = 0.0

func _ready():
	starting_position = global_position
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)

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

	if abs(global_position.x - player.global_position.x) < 10:
		patrol_timer = PATROL_DELAY

	if patrol_timer > 0:
		patrol_timer -= delta
		patrol()
	elif is_following_player and player:
		follow_player()
	else:
		patrol()
	
	if velocity.x != 0:
		sprite.play("walk")
	else:
		sprite.stop()

	move_and_slide()

	if abs(global_position.x - starting_position.x) >= patrol_distance and not is_following_player:
		direction *= -1

	sprite.scale.x = direction

	if jump_timer > 0:
		jump_timer -= delta

func follow_player():
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
