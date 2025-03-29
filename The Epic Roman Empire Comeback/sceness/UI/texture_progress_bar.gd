extends TextureProgressBar

@export var player: Player

func _ready():
	global_player()
	EventController.connect("healed", onHealed)
	player.vidaMudou.connect(update)
	update()

func update():
	value = player.vidaAtual * 100 / player.vidaMax

func onHealed(valor: int):
	update()

#Pega o filho player da cena em que esta instanciado
func global_player():
	if Global.player_instance:
		player = Global.player_instance
