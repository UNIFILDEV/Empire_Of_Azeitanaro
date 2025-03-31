class_name Player extends CharacterBody2D

signal vidaMudou
signal energiaMudou
@onready var end_game: CanvasLayer = $transition
@onready var canvas_layer: CanvasLayer = $CanvasLayer

@export var damage: int = 20
@export var speed: float = 150.0
@export var jump_speed: float = -370.0
@export var sprint_speed: float = 275.0
@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var dash_speed: float = 600.0
@export var dash_duration: float = 0.1
@export var dash_cooldown: float = 0.5

@export var vidaMax: int = 100
@export var vidaAtual: int = 100

@export var energiaMax = 100
@export var energiaAtual = 100
@export var energiaGasto = 10

@onready var sprite = $AnimatedSprite
@onready var collision = $CollisionBody
@onready var attack1box = $Attack1Box
@onready var attack2box = $Attack2Box
@onready var attack3box = $Attack3Box

var hud

const soundJump = preload("res://sceness/player/sounds/jump.wav")
@onready var power_up: AudioStreamPlayer = $PowerUp

var attacking = false
var original_gravity: float = gravity
var attack_type = ""
var is_dashing: bool = false
var dash_timer: float = 0.0
var is_sprinting: bool = false
var jump_sound: AudioStreamPlayer2D
var boxdir = 0
var enemie_in_zone1: bool = false
var enemie_in_zone2: bool = false
var enemie_in_zone3: bool = false
var enemie
var checkpointManager
var is_locked: bool = false
var velocidade = speed

func _ready():
	await get_tree().process_frame
	checkpointManager = get_parent().get_node_or_null("CheckpointManager")
	set_deferred("monitoring", true)
	EventController.connect("healed", onHealed)
	_add_child_soundJump()
	hud = get_parent().get_node_or_null("CanvasLayer")
	
func _physics_process(delta):
	if is_locked:
		velocity.x = 0
		velocity.y += (gravity / 1.5) * delta
		move_and_slide()
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			velocity.x = 0
		move_and_slide()
		return

	if attacking and !attack_type == "attack_2":
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
	speed = velocidade

	if (Input.is_action_pressed("jump")) and is_on_floor():
		jump_sound.play()
		velocity.y = jump_speed

	if (Input.is_action_just_released("jump")):
		if velocity.y < 0:
			velocity.y = -100

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

	if direction != 0 : #andando
		velocity.x = direction * current_speed
		if !attack_type == "attack_2":
			sprite.flip_h = direction < 0
			# Verifique se o 'collision' é válido antes de acessar sua posição
		if is_instance_valid(collision):
			collision.position.x = abs(collision.position.x) * (1 if sprite.flip_h else -1)

	else: #parado
		velocity.x = 0
	if direction != 0:
		boxdir = direction
	
	check_attack()
	update_animation()

	move_and_slide()

func update_animation():
	if attacking:
		return
	if sprite.animation == "sword_channel":
		return
	if is_on_floor():
		if velocity.x == 0:
			if sprite.animation == "hit":
				return  # Garantia que a animação "hit" seja priorizada
			elif sprite.animation != "idle":
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
		else:
			if sprite.animation != "fall":
				sprite.play("fall")
	if sprite.animation == "sword_channel":
		return


func check_attack():
	if Input.is_action_just_pressed("attack_3") and dash_timer <= 0:
		$Attack3Box.position.x = 6 * boxdir
		$Attack3Box.position.y = 10
		if velocity.x == 0:  # Se o player estiver parado
			start_attack("attack_3")
		else:
			start_attack("attack_3")
			start_dash()
		print('ataque 3 apertado')

	elif Input.is_action_just_pressed("attack_1"):
		start_attack("attack_1")
		$Attack1Box.position.x = 10 * boxdir
		print('ataque 1 apertado')

	elif Input.is_action_just_pressed("attack_2"):
		start_attack("attack_2")
		$Attack2Box.scale.x = boxdir
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

func onHealed(valor: int):
	vidaAtual = min(vidaAtual + valor, vidaMax)

func _input(event : InputEvent):
	if(event.is_action_pressed("ui_down") and is_on_floor()):
		position.y += 1

func _add_child_soundJump():
	jump_sound = AudioStreamPlayer2D.new()
	jump_sound.stream = soundJump
	jump_sound.set_volume_db(-21.0)
	add_child(jump_sound)

func take_damage(amount: int):
	sprite.play("hit")
	vidaAtual -= amount
	print('tomou dano')
	vidaMudou.emit()
	print(vidaAtual)
	if vidaAtual <= 0:
		queue_free()
		print('player morreu')
		kill()

func check_attack_1(body):
	if not attacking:
		print("Ataque Cancelado")
	else:
		if attack_type == "attack_1" and sprite.frame == 4:
			body.take_damage(damage*1.5)
			print("Dano no ataque 1, frame ", sprite.frame)

func check_attack_2(body):
	if not attacking:
		print("Ataque Cancelado")
	else:
		if attack_type == "attack_2":
			if sprite.frame == 1:
				body.take_damage(damage*0.5)
				print("Dano no ataque 2, frame ", sprite.frame)
			if sprite.frame == 4:
				body.take_damage(damage*0.5)
				print("Dano no ataque 2, frame ", sprite.frame)
func check_attack_3(body):
	if not attacking:
		print("Ataque Cancelado")
	else:
		if is_instance_valid(body):
			if attack_type == "attack_3" and (sprite.frame == 2 or sprite.frame == 3):
				if is_dashing:
					body.take_damege(damage*2)
					print("Dano no ataque 3 com dash, frame", sprite.frame)
				elif not is_dashing:
					body.take_damage(damage)
					print("Dano no ataque 3, frame", sprite.frame)

func apply_damage_loop(body: EnemyBase) -> void:
	while enemie_in_zone1 or enemie_in_zone2 or enemie_in_zone3:
			#print("Preparando para causar dano...")
			check_attack_1(body)
			check_attack_2(body)
			check_attack_3(body)
			await get_tree().create_timer(0.34).timeout #parâmetro do delay deve estar de acordo com os fps da animação

func take_cura(amount: int):
	vidaAtual += amount
	if vidaAtual > vidaMax:
		vidaAtual = vidaMax
	power_up.play()
	print('pegou vida')
	vidaMudou.emit()
	print(vidaAtual)

func _on_attack_1_box_area_entered(body):
	print("Algo entrou na área de ataque1: ", body.name)
	if body.name == "Hitbox":
		var enemy = body.get_parent()
		if enemy is EnemyBase:  # Confirma que o pai é EnemyBase
			enemie_in_zone1 = true
			enemie = body
			apply_damage_loop(enemy)

func _on_attack_1_box_area_exited(body: Node2D) -> void:
	print("Algo saiu da área de ataque1: ", body.name)
	enemie_in_zone1 = false

func _on_attack_2_box_area_entered(body):
	#print("Algo entrou na área de ataque2: ", body.name)
	if body.name == "Hitbox":
		var enemy = body.get_parent()  # Obtém o nó pai (o inimigo)
		if enemy is EnemyBase and is_instance_valid(body) and attack_type == "attack_2":  # Confirma que o pai é EnemyBase
			enemie_in_zone2 = true
			apply_damage_loop(enemy)

func _on_attack_2_box_area_exited(body: Node2D) -> void:
		enemie_in_zone2 = false

func _on_attack_3_box_area_entered(body):
	#print("Algo entrou na área de ataque3: ", body.name)
	if body.name == "Hitbox":
		var enemy = body.get_parent()  # Obtém o nó pai (o inimigo)
		if enemy is EnemyBase and is_instance_valid(body) and attack_type == "attack_3":  # Confirma que o pai é EnemyBase
			enemie_in_zone3 = true
			apply_damage_loop(enemy)

func _on_attack_3_box_area_exited(body: Node2D) -> void:
		enemie_in_zone3 = false

func danoEspinho():
	if checkpointManager:
		position = checkpointManager.lastLocation
		if has_method("take_damage"):
			take_damage(40)
			sprite.play("hit")
			
	else:
		push_error("Não foi possível reposicionar o Player!")

	
func kill():
	call_deferred("_change_scene_and_play_sound")

func _change_scene_and_play_sound():
	get_tree().change_scene_to_file("res://sceness/selecao_player/selection_player.tscn")
	BgSoundLevel.stop()
	BgSoundMenu.play()
	

func win_fase():
	print("Fim de Fase")
	# Bloquear a movimentação
	is_locked = true
	velocity.x = 0
	sprite.play("sword_channel")
	hud.visible = false
	end_game.visible = true
	end_game.start()
	BgSoundLevel.stop()
	BgSoundEndGame.play()
	if sprite.animation == "sword_channel":
		await sprite.animation_finished
		_change_scene_and_play_sound()
	is_locked = false
