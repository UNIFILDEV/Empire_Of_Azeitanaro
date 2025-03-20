extends TextureProgressBar

@export var player: Player

func _ready():
	if player:
		player.energiaMudou.connect(update)
		update()

func update():
	if player:
		value = (player.energiaAtual / player.energiaMax) * 100
