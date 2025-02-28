extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _addGroup() -> void:
	add_to_group("monsters")  # Adiciona o monstro ao grupo 'monsters'


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#mexendo a partir daqui
var health: int = 5;

func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		queue_free()


	
