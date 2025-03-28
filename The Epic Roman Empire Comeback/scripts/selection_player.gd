extends Control

@onready var player_slots: HBoxContainer = %player_slots
@onready var voltar: Button = $Character_Selection/voltar

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		voltar.grab_focus()

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
	#mapa inicial
	BgSoundMenu.stop()
	get_tree().change_scene_to_file("res://sceness/level/word_start.tscn")


func _on_voltar_pressed() -> void:
	#voltar para a tela principal
	get_tree().change_scene_to_file("res://sceness/start/title_screen.tscn")
