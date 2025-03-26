extends Node
@onready var start_game = $TitleScreen
@onready var seletor_player = $selection_player

func _on_start_pressed() -> void:
	seletor_player.visible = false


func _on_back_button_pressed() -> void:
		seletor_player.visible = true
