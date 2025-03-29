extends Label

var time = 0
var timerOn = true

func _process(delta: float) -> void:
	if (timerOn):
		time += delta
	
	var mili = fmod(time, 1) * 1000
	var seg = fmod(time, 60)
	var min = fmod(time, 3600) / 60
	
	var formatTimer = "%02d : %02d : %03d" % [min, seg, mili]
	$".".text = formatTimer

func stop():
	set_process(false)
