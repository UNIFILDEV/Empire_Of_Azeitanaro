class_name EnemyBase extends CharacterBody2D  # Classe base para inimigos

@export var life: int = 100  # Vida padrão do inimigo
@export var damage: int = 10 # Dano padrão do inimigo
@export var speed: float = 50 # Velocidade padrão do inimigo

func take_damage(amount: int):
	life -= amount
	print("Inimigo tomou dano: ", amount)
	if life <= 0:
		die()

func die():
	print("Inimigo morreu!")
	queue_free()  # Remove o inimigo da cena
