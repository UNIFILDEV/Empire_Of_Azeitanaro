extends Area2D

# Variáveis para contagem
var ingredCorreto = 0
var ingredIncorreto = 0
var chances = 6

# Ingredientes corretos e incorretos
var ingredientes_corretos = ["Pimentao", "Cogumelo", "Alcachofra", "Azeitona"]
var ingredientes_incorretos = ["Chocolate", "Ketchup", "Frango"]

func _ready():
	# Conectando o sinal de colisão para a área
	connect("body_entered", self._on_ingredient_picked)

# Função que é chamada quando o jogador entra na área
func _on_ingredient_picked(body):
	if body.is_in_group("jogador"):  # Verifica se o corpo que entrou é o jogador
		var nome_ingrediente = get_child(0).name  # Acessa o nome do primeiro ingrediente na área
		if nome_ingrediente in ingredientes_corretos:
			ingredCorreto += 1
			print("Ingrediente correto! Contagem: ", ingredCorreto)
		elif nome_ingrediente in ingredientes_incorretos:
			ingredIncorreto += 1
			print("Ingrediente incorreto! Contagem: ", ingredIncorreto)
		
		chances -= 1
		print("Chances restantes: ", chances)

		# Verificar se acabou as chances
		if chances <= 0:
			print("Fim do jogo!")
			# Aqui você pode colocar a lógica para finalizar o jogo ou reiniciar
