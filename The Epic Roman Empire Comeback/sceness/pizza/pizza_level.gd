extends Node2D

var ingredCorreto = 0 # 4 ingredientes corretos
var ingredIncorreto = 0 # 3 ingredientes incorretos
var tentativas = 0

# Ingredientes corretos e incorretos
var ingredientes_corretos = ["pimentao", "cogumelo", "alcachofra", "azeitona"]
var ingredientes_incorretos = ["chocolate", "ketchup", "frango"]

func _ready():
	# Conecta o sinal de colisão para todos os filhos de area_all_ingredients
	var area_ingredientes = $area_all_ingredients
	for area in area_ingredientes.get_children():
		if area is Area2D:
			area.connect("body_entered", self._on_ingredient_picked)

func _on_ingredient_picked(body):
	if body.is_in_group("player"):  # Verifica se o corpo que colidiu é o jogador
		var nome_ingrediente = body.name  # Pega o nome do ingrediente que colidiu
		if nome_ingrediente in ingredientes_corretos:
			ingredCorreto += 1
			print("Ingrediente correto! Contagem: ", ingredCorreto)
			if ingredCorreto == 4 and tentativas == 4:
				print("Acertou todos os ingredientes com perfeição! Você passou de fase.")
			elif ingredCorreto == 4 and tentativas == 5:
				print("A pizza ficou meio porca, mas você conseguiu passar de fase.")
		elif nome_ingrediente in ingredientes_incorretos:
			ingredIncorreto += 1
			print("Ingrediente incorreto! Contagem: ", ingredIncorreto)
			if ingredIncorreto >= 2:
				body.queue_free()  # Remove o item incorreto após 2 erros
		tentativas += 1
		print("Tentativas realizadas: ", tentativas)

		# Verificar se as tentativas acabaram
		if tentativas >= 6:
			print("Fim do jogo! Tentativas esgotadas.")
			# Aqui pode adicionar lógica para finalizar ou reiniciar o jogo
