class_name EnemyBase extends CharacterBody2D  # Classe base para inimigos

var rng = RandomNumberGenerator.new()
@export var life: int = 100  # Vida padrão do inimigo
@export var damage: int = 10 # Dano padrão do inimigo
@export var speed: float = 50 # Velocidade padrão do inimigo
@onready var sprite = $AnimatedSprite

func take_damage(amount: int):
	sprite.play("hit")
	life -= amount
	print("Inimigo tomou dano: ", amount)
	if life <= 0:
		die()
	else:
		velocity.y = -180
		velocity.x = -400*rng.randi_range(-1, 1)

func die():
	print("Inimigo morreu!")
	queue_free()  # Remove o inimigo da cena
