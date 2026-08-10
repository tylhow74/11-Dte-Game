extends Node

var time_left = 180

func _ready():
	$UI/Timer.start()

func _process(delta):
	time_left -= delta
	$Label.text = str(ceil(time_left))

	if time_left <= 0:
		time_left = 0
		$Timer.stop()
		print("Time's up!")
