extends Node2D
@onready var player: Node2D = get_tree().get_first_node_in_group("Player")
var explosion = load('res://DevlynScenes/explosion.tscn')
var speed = randf_range(2,7)
var life_time = 2
func _process(delta: float) -> void:
	life_time -= delta
	self.position += Vector2(speed, 0).rotated(self.rotation)
	if ($RayCast2D.is_colliding()):
		print("hit")
		var hud = get_tree().get_first_node_in_group("hud")
		if hud:
			hud.add_hit()
		explode()
	else:
		player = get_tree().get_first_node_in_group("Player")
		var rotate_angle = (player.global_position - global_position).angle()
		rotation = lerp_angle(rotation, rotate_angle, 1 * delta)
	
	if not get_viewport().get_visible_rect().has_point(global_position):
		explode()
	
	if life_time <= 0:
		self.scale -= Vector2(0.01, 0.01)
		self.scale -= Vector2(0.01, 0.01)
		self.scale -= Vector2(0.01, 0.01)
		if self.scale <= Vector2(0,0):
			explode()
	var boss = get_tree().get_first_node_in_group("boss")
	if !boss:
		queue_free()

func explode() -> void:
	var e = explosion.instantiate()
	e.position = self.position
	e.rotation = self.rotation 
	get_parent().add_child(e)
	queue_free()
	
