extends Node2D

@export var valorCura: int = 3
@export var amplitude: float = 3.0
@export var speed: float = 10.0

var base_position: Vector2

func _ready() -> void:
	base_position = position

func _process(delta: float) -> void:
	var offset_y = sin(Time.get_ticks_msec() / 1000.0 * speed) * amplitude
	position = base_position + Vector2(0, offset_y)

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body is Player:
		GameController.healed(valorCura * 10)
		body.take_cura(valorCura * 10)
		LifeUpSound.play()
		queue_free()
