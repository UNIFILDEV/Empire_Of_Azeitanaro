extends Node2D

@onready var player_spawn: Marker2D = $player_spawn_point

func _ready() -> void:
	if Global.player_instance:
		Global.player_instance.position = $player_spawn_point.position
		Global.add_player_to_scene(self)
