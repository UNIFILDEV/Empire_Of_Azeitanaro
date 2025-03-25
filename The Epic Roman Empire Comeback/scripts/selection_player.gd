extends Control

@onready var player_slots: HBoxContainer = %player_slots

func _ready() -> void:
	for button in player_slots.get_children():
		if button is MarginContainer:
			# Verifique os filhos do MarginContainer
			for child in button.get_children():
				if child is TextureButton:
					child.set_meta("player_scene", "res://sceness/player/" + child.name + ".tscn")
					child.pressed.connect(Callable(self, "on_pressed_button").bind(child))

func on_pressed_button(button):
	var character_path = button.get_meta("player_scene")
	if character_path:
		Global.selected_character = character_path
		start_game()

func start_game():
	get_tree().change_scene_to_file("res://sceness/level/MapaTeste.tscn")
