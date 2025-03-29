extends Area2D

func _on_body_entered(body):
	print("Morreste!")
	get_tree().change_scene_to_file("res://sceness/start/title_screen.tscn")
