extends AnimatedSprite2D

var health: int = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flip_h = true  # Faz o sprite ficar permanentemente virado para a esquerda

func _addGroup() -> void:
	add_to_group("monsters")  # Adiciona o monstro ao grupo 'monsters'

# Função que reduz a saúde do monstro e o remove se a saúde acabar
func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# O sprite já está configurado para sempre olhar para a esquerda, nada a fazer aqui
	pass
