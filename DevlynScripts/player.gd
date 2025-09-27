extends Node2D
var cooldown = 1
var current_cooldown = 0
func _process(delta: float) -> void:
	current_cooldown -= delta
	self.position = get_global_mouse_position()
	
	if Input.is_key_pressed(KEY_F) && current_cooldown <= 0:
		current_cooldown = cooldown
		var boss = get_tree().get_first_node_in_group("boss")
		if boss:
			boss.take_damage()
