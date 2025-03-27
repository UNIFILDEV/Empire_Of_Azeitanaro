extends Node2D

@onready var player_spawn: Marker2D = $player_spawn_point

func _ready() -> void:
	if not is_instance_valid(player_spawn):
		print("ERRO: O nó 'player_spawn' não foi encontrado!")
		return

	if Global.selected_character:
		var character_scene = load(Global.selected_character)
		var character_instance = character_scene.instantiate()
		add_child(character_instance)
		character_instance.global_position = player_spawn.global_position
		character_instance.add_to_group("player")
		get_tree().root.print_tree_pretty()
