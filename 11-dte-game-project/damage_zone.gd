extends Area2D

@export var damage = 10

func _on_body_entered(DamageZone):
	print("Zone hit:", DamageZone.name)

	if DamageZone.has_method("take_damage"):
		DamageZone.take_damage(damage)
