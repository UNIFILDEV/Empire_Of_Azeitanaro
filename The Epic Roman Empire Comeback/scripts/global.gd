extends Node

var _selected_character = null  # Caminho da cena do player
var player_instance = null  # Guarda a instância do player

var selected_character: 
	get:
		return _selected_character
	set(value):
		_selected_character = value
		_instantiate_player(value)

func _instantiate_player(path):
	if ResourceLoader.exists(path):
		
		var player_scene = load(path)
		player_instance = player_scene.instantiate()
		
		print("Nova instância do player criada para:", path)
	else:
		push_error("Cena do player não encontrada: " + path)

func add_player_to_scene(scene_node):
	if player_instance and scene_node:
		scene_node.add_child(player_instance)
		print("Player adicionado à cena:", scene_node.name)
	else:
		push_error("Falha ao adicionar Player. Cena ou instância inválida.")
