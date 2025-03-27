extends Node

var _selected_character = null  # Armazena o caminho da cena
var player_instance = null  # Guarda a instância do player

var selected_character: 
	get:
		return _selected_character
	set(value):
		_selected_character = value
		_instantiate_player(value)

# Método para instanciar o player automaticamente
func _instantiate_player(path):
	if ResourceLoader.exists(path):
		var player_scene = load(path)
		player_instance = player_scene.instantiate()
		print("Nova instância do player criada para:", path)
	else:
		push_error("Cena do player não encontrada: " + path)
