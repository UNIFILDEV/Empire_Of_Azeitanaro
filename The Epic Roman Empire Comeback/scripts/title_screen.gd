extends Control

@onready var exit: Button = %exit
@onready var start: Button = %start

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		exit.grab_focus()
	if event.is_action_pressed("ui_up") || event.is_action_pressed("ui_down"):
		start.grab_focus()

func _ready() -> void:
	start.pressed.connect(_on_start_pressed)
	exit.pressed.connect(_on_exit_pressed)
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://sceness/selecao_player/selection_player.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
