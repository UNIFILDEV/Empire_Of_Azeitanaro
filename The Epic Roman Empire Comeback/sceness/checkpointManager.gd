extends Area2D

var checkpointManager

func _ready() -> void:
	checkpointManager = get_parent().get_parent().get_node("CheckpointManager")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		checkpointManager.lastLocation = $RespawnPoint.global_position
		changeSprite()

func changeSprite():
	var texture = load("res://assets/assestLombaLomba/Assets/checkpointActive.png")
	$Sprite2D.texture = texture
