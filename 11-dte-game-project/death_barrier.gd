extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		await get_tree().create_timer(0.5).timeout
		get_tree().reload_current_scene()
