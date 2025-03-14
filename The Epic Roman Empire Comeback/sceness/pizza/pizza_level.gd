extends Node2D

var ingredCorreto = 0 #4
var ingredIncorreto = 0 #3
var tentativas = 0

# Referência para o nó `Area2D`
onready var area_ingredientes = $Area2D

# Ingredientes corretos e incorretos
var ingredientes_corretos = ["pimentao", "cogumelo", "alcachofra", "azeitona"]
var ingredientes_incorretos = ["chocolate", "ketchup", "frango"]

func _ready():
	# Conectando os sinais de colisão para a área de ingredientes
	area_ingredientes.connect("body_entered", self, "_on_ingredient_picked")

func _on_ingredient_picked(body):
	if body.is_in_group("jogador"):
		var nome_ingrediente = body.name  # Pega o nome do ingrediente
		if nome_ingrediente in ingredientes_corretos:
			ingredCorreto += 1
			print("Ingrediente correto! Contagem: ", ingredCorreto)
			if ingredCorreto == 4 and tentativas == 4:
				print('Acertou todos os ingredientes com perfeição! Você é um italiano nato. Passou de fase')
			if ingredCorreto == 4 and tentativa == 5:
				print('A pizza ficou meio porca mas você conseguiu. Você é um italiano nacionalizado. Passou de fase')
		elif nome_ingrediente in ingredientes_incorretos:
			ingredIncorreto += 1
			print("Ingrediente incorreto! Contagem: ", ingredIncorreto)
			if ingredIncorreto == 2 or chances == 6:
				body.queue_free()
		tentativas += 1
		print("Tentativas realizadas: ", tentativas)

		# Verificar se as chances acabaram
		#if tentativas <= 0:
			#print("Fim do jogo! Você não é um italiano de honra!")
			## Aqui você pode colocar a lógica para finalizar o jogo ou reiniciar
