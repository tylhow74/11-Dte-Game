extends Node

var bananas_collected = 0
var total_bananas = 10

func collect_banana():
	bananas_collected += 1

	if bananas_collected >= total_bananas:
		win_game()

func win_game():
	print("YOU WIN!")
	get_tree().change_scene_to_file("res://winscreen.tscn")
