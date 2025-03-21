extends Control

@onready var label = $Label

func _ready() -> void:
	EventController.connect("coin_collected", on_event_coin_collected)

func on_event_coin_collected(valor):
	print("Evento recebido! Novo valor:", valor)
	label.text = str(valor)
