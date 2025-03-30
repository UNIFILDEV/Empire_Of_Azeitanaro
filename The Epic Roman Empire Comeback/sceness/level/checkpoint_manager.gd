extends Node

var lastLocation
var player

func _ready() -> void:
	await get_tree().process_frame

	player = get_parent().get_node_or_null("Player")
	
	if player:
		lastLocation = player.global_position
	else:
		push_error("Player não encontrado na cena!")
