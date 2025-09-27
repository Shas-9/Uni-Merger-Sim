extends Node2D

var life_time = 8
func _process(delta: float) -> void:
	life_time -= delta
	if ($RayCast2D.is_colliding()):
		print("hit")
		var hud = get_tree().get_first_node_in_group("hud")
		if hud:
			hud.add_hit()
	var boss = get_tree().get_first_node_in_group("boss")
	if !boss:
		queue_free()
	if life_time <= 0:
		queue_free()
		
	
