extends Node2D
var bullet = load('res://DevlynScenes/homing_bullet.tscn')
@onready var firepoint: Node2D = $Sprite2D/FirePoint
var fire_rate: float = .2  # seconds between bullets
var time_since_last_shot: float = 0.0
var max_bullets = 10
var bullets_shot = 0

func _process(delta: float) -> void:
	time_since_last_shot += delta
	rotate(.01)
	if time_since_last_shot >= fire_rate:
		bullets_shot += 1
		shoot_bullet()
		time_since_last_shot = 0
		
	if bullets_shot >= max_bullets:
		queue_free()
		
func shoot_bullet() -> void:
	var b = bullet.instantiate()
	b.global_position = firepoint.global_position
	b.global_rotation = firepoint.global_rotation
	get_tree().current_scene.add_child(b)
	
