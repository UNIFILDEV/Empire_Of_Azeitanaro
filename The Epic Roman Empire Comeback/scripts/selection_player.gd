extends Control

@onready var player_slots: HBoxContainer = %player_slots
@onready var voltar: Button = $Character_Selection/voltar
@onready var first_player_btn: TextureButton = %player

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		voltar.grab_focus()

func _ready() -> void:
	first_player_btn.grab_focus()
	for button in player_slots.get_children():
		if button is MarginContainer:
			# Verifique os filhos do MarginContainer
			for child in button.get_children():
				if child is TextureRect:
					# Agora verificamos os filhos do TextureRect
					for sub_child in child.get_children():
						if sub_child is TextureButton:
							sub_child.set_meta("player_scene", "res://sceness/player/" + sub_child.name + ".tscn")
							sub_child.pressed.connect(Callable(self, "on_pressed_button").bind(sub_child))


func on_pressed_button(button):
	var character_path = button.get_meta("player_scene")
	if character_path:
		Global.selected_character = character_path
		start_game()

func start_game():
	#mapa inicial
	BgSoundMenu.stop()
	get_tree().change_scene_to_file("res://sceness/level/Level.tscn")


func _on_voltar_pressed() -> void:
	#voltar para a tela principal
	get_tree().change_scene_to_file("res://sceness/start/title_screen.tscn")
