extends Node2D
@onready var player_spawn_point: Marker2D = %player_spawn_point
@onready var music_player_1: AudioStreamPlayer = $AudioStreamPlayerIntro #menu

func _ready() -> void:
	music_player_1.play()
	if Global.selected_character:
		var character_scene = load(Global.selected_character)
		var character_instance = character_scene.instantiate()
		add_child(character_instance)
		character_instance.position = player_spawn_point.global_position
