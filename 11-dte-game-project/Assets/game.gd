extends Node

var bananas_collected = 0
var total_bananas = 8

func collect_banana():
	bananas_collected += 1

	if bananas_collected >= total_bananas:
		win_game()

func win_game():
	print("YOU WIN!")
	get_tree().change_scene_to_file("res://winscreen.tscn")

@onready var timer = $Timer
@onready var label = $Timer/Label

func _ready():
	timer.start()

func _process(delta):
	label.text = str(ceil(timer.time_left))

func _on_timer_timeout():
	var death_screen = get_tree().get_first_node_in_group("death_screen")

	if death_screen == null:

		print("STILL NO DEATH SCREEN (GROUP NOT FOUND)")

		return

	death_screen.show_death_screen()

	get_tree().paused = true
