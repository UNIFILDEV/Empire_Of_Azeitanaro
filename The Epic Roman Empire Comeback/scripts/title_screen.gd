extends Control

@onready var exit: Button = %exit
@onready var start: Button = %start
@onready var music_player_1: AudioStreamPlayer = %AudioStreamPlayerMenu
@onready var transition: CanvasLayer = $bg/transition

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		exit.grab_focus()

func _ready() -> void:
	start.grab_focus()
	start.pressed.connect(_on_start_pressed)
	exit.pressed.connect(_on_exit_pressed)
	music_player_1.play()
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://sceness/selecao_player/selection_player.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
