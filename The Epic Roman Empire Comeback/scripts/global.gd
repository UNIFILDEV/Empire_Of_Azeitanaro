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
		var new_player_instance = player_scene.instantiate()

		# Se já houver um player instanciado, removemos ele da cena antes de substituir
		if player_instance and is_instance_valid(player_instance):
			player_instance.queue_free()
			await player_instance.tree_exited
		
		player_instance = new_player_instance
		print("Nova instância do player criada para:", path)
	else:
		push_error("Cena do player não encontrada: " + path)

func add_player_to_scene(scene_node):
	if player_instance and scene_node:
		
		if player_instance.get_parent():
			player_instance.get_parent().remove_child(player_instance)

		scene_node.add_child(player_instance)
		print("Player adicionado à cena:", scene_node.name)
	else:
		push_error("Falha ao adicionar Player. Cena ou instância inválida.")
