extends Area2D

@onready var timer = $Timer

func _on_body_entered(body):
	print("Morreste!")
	timer.start()
	body.get_node("Collision_Body").queue_free()
	Engine.time_scale = 0.4

func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
