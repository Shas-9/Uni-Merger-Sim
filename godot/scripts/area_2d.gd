extends CharacterBody2D

func _mouse_enter() -> void:
	get_parent().mouseEnter()

func stop_movement():
	get_parent().stop_movement()

func resume_movement():
	get_parent().resume_movement()
