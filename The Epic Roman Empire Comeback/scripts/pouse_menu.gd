extends CanvasLayer
@onready var animator: AnimationPlayer = $animator

func _ready() -> void:
	animator.play('open')
	await animator.animation_finished
	visible = false
