extends Area2D
#@export var width: int = 8
@onready var collision: CollisionShape2D = $collision
@onready var spikes: Sprite2D = $spikes

func _process(delta: float) -> void:
	#sprite_espinho.set_rect(width)
	collision.shape.size = spikes.get_rect().size

func _on_body_entered(body: CharacterBody2D) -> void:
	if(body.name == "Player"):
		#body.take_damage(Vector2(0, -250))
		print("player está nos espinhos")
