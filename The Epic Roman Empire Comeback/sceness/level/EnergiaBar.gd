extends TextureProgressBar

@export var player: Player

func _ready():
	player.energiaMudou.connect(update)

func update():
	value = player.energiaAtual * 100 / player.energiaMax
