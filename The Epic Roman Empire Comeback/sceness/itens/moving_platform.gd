extends Node2D

const wait_duration := 1.0

@onready var platform := $platform as AnimatableBody2D;
@export var move_speed: float = 3.0
@export var distance:float = 192.0
@export var move_vertical := true

var follow := Vector2.ZERO
var platform_center := 16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_platform()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	platform.position = platform.position.lerp(follow, 0.5)
	
func move_platform():
	var move_direction := Vector2.UP * distance if move_vertical else Vector2.RIGHT * distance
	var duration = move_direction.length()/float(move_speed * platform_center)
	
	var platform_tween = create_tween()
	platform_tween.set_loops()  # Ajuste a quantidade de loops conforme necessário
	platform_tween.tween_property(self, "follow", move_direction, duration)
	platform_tween.tween_property(self, "follow", Vector2.ZERO, duration)
	
