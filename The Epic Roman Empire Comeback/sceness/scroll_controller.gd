extends Node2D

const speed = 150
const sprintSpeed = 275

func _process(delta: float) -> void:
	var eixo = Input.get_axis("left", "right")
	
	if Input.is_action_pressed("sprint"):
		position.x += eixo * sprintSpeed * delta
	else:
		position.x += eixo * speed * delta
