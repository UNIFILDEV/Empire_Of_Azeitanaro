extends Area2D
#var totalCoins: int = 0
#onready var sound_player = $AudioStreamPlayer;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	#totalCoins += 1;
	#sound_player.play();
	if body.name == "Player":
		print('pegou na moeda');
		#$AudioStreamPlayer2D.play()
		queue_free();
	#print(totalCoins);
# ele só ta fazendo o print na moeda fora do nó2d, e o som nao toca, e tb qndo inicia o som toca n sei pq
