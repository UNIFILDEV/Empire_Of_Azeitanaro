extends Node2D

@export var valor: int = 1
@onready var coin: AudioStreamPlayer = $Coin

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body is Player:
		GameController.coin_collected(valor)
		print("Colisão entre: ", body.name)
		
		var tween = create_tween()
		tween.tween_property(self, "position", position + Vector2(0, -30), 0.5)
		coin.play()
		await coin.finished
		queue_free()
