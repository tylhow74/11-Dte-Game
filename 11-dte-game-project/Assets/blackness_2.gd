extends Area2D

@onready var dark_overlay = $ColorRect

func _ready():
	body_entered.connect(player_entered)
	body_exited.connect(player_left)

func player_entered(body):
	print("ENTERED:", body.name)
	if body.name == "Player":
		dark_overlay.visible = true
		dark_overlay.color = Color(0, 0, 0, 0.5)

func player_left(body):
	if body.name == "Player":
		dark_overlay.visible = false
