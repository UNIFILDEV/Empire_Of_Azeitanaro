class_name EnemyBase extends CharacterBody2D  # Classe base para inimigos

var rng = RandomNumberGenerator.new()
@export var life: int = 1000  # Vida padrão do inimigo
@export var damage: int = 10 # Dano padrão do inimigo
@export var speed: float = 50 # Velocidade padrão do inimigo

@onready var sprite = $AnimatedSprite

func take_damage(amount: int):
	velocity.y = -100
	velocity.x = -200*rng.randi_range(-1, 1)
	sprite.play("hit")
	life -= amount
	print("Inimigo tomou dano: ", amount)
	if life <= 0:
		die()

func die():
	print("Inimigo morreu!")
	queue_free()  # Remove o inimigo da cena
