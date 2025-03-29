extends CanvasLayer

@onready var animator: AnimationPlayer = $animator

func _ready() -> void:
	visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		visible = true
		animator.play("pause_game")
		
func _on_resume_btn_pressed() -> void:
	animator.play("resume_game")
	await animator.animation_finished
	visible = false

func _on_exit_btn_pressed() -> void:
	animator.play("exit_game")
	await animator.animation_finished
	get_tree().paused = false
	visible = false
	BgSoundMenu.play()
	get_tree().change_scene_to_file("res://sceness/start/title_screen.tscn")
	
	
