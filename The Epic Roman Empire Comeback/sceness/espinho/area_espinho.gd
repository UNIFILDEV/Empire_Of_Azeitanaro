extends Area2D


#@onready var collision = $collision_espinho
#@onready var sprite = $sprite_espinho
#func _ready() -> void:
	#collision.shape.size = sprite.get_rect().size
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if(body.name == "Player"):
		print("player está nos espinhos")
