extends Node2D

@export var valorCura: int = 3
@export var amplitude: float = 8.0
@export var speed: float = 20.0

var base_position: Vector2

func _ready() -> void:
	base_position = position

func _process(delta: float) -> void:
	var offset_y = sin(Time.get_ticks_msec() / 1000.0 * speed) * amplitude
	position = base_position + Vector2(0, offset_y)

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body is Player:
		print(body)
		queue_free()
