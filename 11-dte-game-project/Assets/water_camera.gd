extends Area2D

@onready var water_overlay = $ColorRect

func _ready():
	body_entered.connect(player_entered)
	body_exited.connect(player_left)

func player_entered(body):
	print("ENTERED:", body.name)
	if body.name == "Player":
		water_overlay.visible = true

func player_left(body):
	if body.name == "Player":
		water_overlay.visible = false
