extends Node2D

var life_time = 2
func _process(delta: float) -> void:
	life_time -= delta
	if self.scale <= Vector2(.5,.5):
		self.scale += Vector2(0.01, 0.01)
	else:
		self.scale -= Vector2(0.01, 0.01)
	rotate(.01)
	if ($RayCast2D.is_colliding()):
		print("hit")
		var hud = get_tree().get_first_node_in_group("hud")
		if hud:
			hud.add_hit()
	if life_time <= 0:
		self.scale -= Vector2(0.01, 0.01)
		self.scale -= Vector2(0.01, 0.01)
		self.scale -= Vector2(0.01, 0.01)
		if self.scale <= Vector2(0,0):
			queue_free()
		
	
