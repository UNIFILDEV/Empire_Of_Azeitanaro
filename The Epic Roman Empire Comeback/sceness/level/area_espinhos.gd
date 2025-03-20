extends Area2D

@onready var collision = $collision as CollisionShape2D
@onready var sprite = $sprite as Sprite2D

#
 	 #Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision.shape.size = sprite.get_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("player nos espihnos")
		body.take_damage(Vector2(0, -250))
		
		
		
