extends Area2D

@export var damage = 10

func _on_damage_zone_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(10)
