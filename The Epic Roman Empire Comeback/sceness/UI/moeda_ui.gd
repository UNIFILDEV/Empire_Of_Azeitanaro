extends Control

@export var player: Player
@onready var label = $Label

func _ready() -> void:
	global_player()
	EventController.connect("coin_collected", on_event_coin_collected)
	
func on_event_coin_collected(valor):
	if valor >= 100:
		LifeUpSound.play()
		valor -= 100
		label.text = str(valor)
		if player:
			player.take_cura(120)
	else:
		label.text = str(valor)
	print("Evento recebido! Novo valor:", valor)

func global_player():
	if Global.player_instance:
		player = Global.player_instance
