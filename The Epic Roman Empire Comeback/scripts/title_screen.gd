extends Control

@onready var exit: Button = $bg/MarginContainer/HBoxContainer/button_slots/exit
@onready var start: Button = $bg/MarginContainer/HBoxContainer/button_slots/start
@onready var music_player_1: AudioStreamPlayer = $AudioStreamPlayerMenu #menu

func _ready() -> void:
	start.pressed.connect(_on_start_pressed)
	exit.pressed.connect(_on_exit_pressed)
	music_player_1.play()
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://sceness/selecao_player/selection_player.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
