extends CharacterBody2D

func _mouse_enter() -> void:
	get_parent().mouseEnter()

func stop_movement():
	can_move = false

func resume_movement():
	can_move = true
