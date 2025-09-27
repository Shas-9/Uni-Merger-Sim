extends Node2D

func _process(delta: float) -> void:
	self.position += Vector2(1, 0).rotated(self.rotation)
	
	if ($RayCast2D.is_colliding()):
		print("hit")
		var hud = get_tree().get_first_node_in_group("hud")
		if hud:
			hud.add_hit()
		queue_free()
	if not get_viewport().get_visible_rect().has_point(global_position):
		queue_free()
