extends Area2D

var checkpointManager
var player
@onready var hurt: AudioStreamPlayer = $Hurt

func _ready() -> void:
	await get_tree().process_frame

	checkpointManager = get_parent().get_node_or_null("CheckpointManager")
	player = get_parent().get_node_or_null("Player")

	# Verifica se os nós foram encontrados
	if not checkpointManager:
		push_error("CheckpointManager não encontrado!")
	if not player:
		push_error("Player não encontrado!")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		hurt.play()
		danoVoidPlayer()

func danoVoidPlayer():
	if player and checkpointManager:
		player.position = checkpointManager.lastLocation
		if player.has_method("take_damage"):
			player.take_damage(20)
	else:
		push_error("Não foi possível reposicionar o Player!")
