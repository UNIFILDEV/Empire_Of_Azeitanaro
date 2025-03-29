extends TextureProgressBar

@export var player: Player

func _ready():
	global_player()
	if player:
		player.energiaMudou.connect(update)
		update()

func update():
	if player:
		value = (player.energiaAtual / player.energiaMax) * 100

#Pega o filho player da cena em que esta instanciado
func global_player():
	if Global.player_instance:
		player = Global.player_instance
