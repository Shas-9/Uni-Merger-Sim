extends Node2D

func _process(delta: float) -> void:
	self.position += Vector2(1, 0).rotated(self.rotation)
	
	if ($RayCast2D.is_colliding()):
		print("hit")
		queue_free()
 
