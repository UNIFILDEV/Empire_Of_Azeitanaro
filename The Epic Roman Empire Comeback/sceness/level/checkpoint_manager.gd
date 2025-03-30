extends Node

var lastLocation
var player

func _ready() -> void:
	player = get_parent().get_node("Player")
	lastLocation = player.global_position
