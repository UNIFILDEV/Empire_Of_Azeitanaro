extends CanvasLayer

@onready var resume_btn: Button = $bg_overlay/menu_holder/resume_btn
@onready var exit_btn: Button = $bg_overlay/menu_holder/exit_btn
@onready var animator: AnimationPlayer = $animator

func _ready() -> void:
	visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		visible = true
		animator.play("pause_game")
		get_tree().paused = true
		resume_btn.grab_focus()

func _on_resume_btn_pressed() -> void:
	animator.play("resume_game")
	get_tree().paused = false
	await animator.animation_finished
	visible = false

func _on_exit_btn_pressed() -> void:
	animator.play("exit_game")
	await animator.animation_finished
	get_tree().paused = false
	visible = false
	BgSoundMenu.play()
	get_tree().change_scene_to_file("res://sceness/start/title_screen.tscn")
	
	
