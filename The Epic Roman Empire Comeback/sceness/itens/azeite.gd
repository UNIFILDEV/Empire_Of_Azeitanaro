extends Node2D

@export var valorCura: int = 3


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body is Player:
		GameController.healed(valorCura * 10)
		queue_free()
