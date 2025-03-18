extends ProgressBar

@export var player: Player

func _ready():
	EventController.connect("healed", onHealed)
	player.vidaMudou.connect(update)
	update()

func update():
	value = player.vidaAtual * 100 / player.vidaMax

func onHealed(valor: int):
	update()
