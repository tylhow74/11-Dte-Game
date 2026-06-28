extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

func show_death_screen():
	show()

func hide_death_screen():
	hide()
	get_tree().paused = false

func _on_restartbutton_pressed() -> void:
		get_tree().paused = false
		get_tree().reload_current_scene()
