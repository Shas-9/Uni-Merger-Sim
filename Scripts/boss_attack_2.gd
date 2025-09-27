extends Node2D
@onready var player: Node2D = get_tree().get_first_node_in_group("Player")
var lazer = load('res://Scenes/laser.tscn')
var fire_rate: float = 4  # seconds between bullets
var time_since_last_shot: float = 0.0
var max_bullets = 1
var bullets_shot = 0
func _process(delta: float) -> void:
	time_since_last_shot += delta
	if time_since_last_shot >= fire_rate:
		await get_tree().create_timer(1.0).timeout	
		shoot_bullet()
		bullets_shot += 1
		time_since_last_shot = 0
	else:
		player = get_tree().get_first_node_in_group("Player")
		var rotate_angle = (player.global_position - global_position).angle() + deg_to_rad(-90)
		rotation = lerp_angle(rotation, rotate_angle, 2 * delta)
		
		
	if bullets_shot >= max_bullets:
		queue_free()

func shoot_bullet() -> void:
	var l = lazer.instantiate()
	l.position = self.position
	l.rotation = self.rotation
	
	get_parent().add_child(l)
