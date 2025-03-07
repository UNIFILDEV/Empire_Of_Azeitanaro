extends CharacterBody2D

const SPEED = 700.0
const JUMP_VELOCITY = -400.0
var direction := -1  # Direção inicial (esquerda)

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite = $AnimatedSprite2D  # Assumindo que o AnimatedSprite2D está como filho do personagem

# Função que altera a direção a cada 5 segundos
func _ready():
	# Criação e configuração do Timer
	var timer = Timer.new()
	add_child(timer)  # Adiciona o Timer à cena
	timer.wait_time = 5  # Define o intervalo para 5 segundos
	timer.one_shot = false  # Define para o Timer ser repetitivo
	timer.start()

	# Conecta o sinal timeout do timer à função que inverte a direção
	timer.timeout.connect(self._on_timer_timeout)

# Função que inverte a direção a cada vez que o Timer dispara
func _on_timer_timeout() -> void:
	direction *= -1  # Inverte a direção (se estava -1, vai para 1 e vice-versa)
	sprite.flip_h = direction == 1  # Se a direção for 1 (direita), flip_h será true

func _physics_process(delta: float) -> void:
	# Adiciona a gravidade.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Move o personagem conforme a direção (invertendo a direção a cada 5 segundos)
	velocity.x = direction * SPEED * delta
	
	# Verifica se o monstro está se movendo e ajusta a animação
	if velocity.x != 0:
		sprite.play("walk")  # Assume que a animação "walk" está correta
	else:
		sprite.play("standing")  # Se o monstro não se mover, toca a animação "standing"

	move_and_slide()
