extends Area2D

var checkpointManager
var player

func _ready() -> void:
	checkpointManager = get_parent().get_node("CheckpointManager")
	player = get_parent().get_node("Player")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		killPlayer()

func killPlayer():
	player.position = checkpointManager.lastLocation
