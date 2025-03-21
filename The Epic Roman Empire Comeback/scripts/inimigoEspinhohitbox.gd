extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"


## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
#ataque pisando
var life = 2
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print('deu dano')
		life -= 2
		animated_sprite_2d.play("hurt")
		if life == 0:
			owner.queue_free()
			
			
