extends Node2D

var bullet_scene = load('res://DevlynScenes/bullet.tscn')
@export var fire_rate: float = .04  # seconds between bullets
var time_since_last_shot: float = 0.0
var max_bullets = 500
var bullets_shot = 0
func _process(delta: float) -> void:
	time_since_last_shot += delta
	if bullets_shot >= max_bullets/2:
		rotate(2)
	else:
		rotate(-2)
	if time_since_last_shot >= fire_rate:
		shoot_bullet()
		bullets_shot += 1
		time_since_last_shot = 0
	
	
	if bullets_shot >= max_bullets:
		queue_free()

func shoot_bullet() -> void:
	var b = bullet_scene.instantiate()
	b.position = self.position
	b.rotation = self.rotation
	get_parent().add_child(b)
