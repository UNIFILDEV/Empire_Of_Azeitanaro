extends Node
@onready var transition_load_game: CanvasLayer = $transition_load_game

func _ready() -> void:
	BgSoundMenu.stop()

func _on_animator_animation_finished(anim_name: StringName) -> void:
	transition_load_game.visible = false
	BgSoundMenu.play()
