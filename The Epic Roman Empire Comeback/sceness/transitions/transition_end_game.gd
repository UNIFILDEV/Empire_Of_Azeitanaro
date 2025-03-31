extends CanvasLayer

@onready var animator: AnimationPlayer = $animator

func start():
	animator.play()


func _on_voltar_pressed() -> void:
	BgSoundEndGame.stop()
	get_tree().change_scene_to_file("res://sceness/start/title_screen.tscn")
	BgSoundMenu.play()
