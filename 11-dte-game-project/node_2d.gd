extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.has_method("_on_water_body_entered"):
		body._on_water_body_entered(body)

func _on_body_exited(body):
	if body.has_method("on_body_exited"):
		body._on_water_body_exited(body)
