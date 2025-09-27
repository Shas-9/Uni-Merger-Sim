extends Node2D

var attack_1 = load('res://Scenes/boss_attack_1.tscn')
var attack_2 = load('res://Scenes/boss_attack_2.tscn')
var attack_3 = load('res://Scenes/boss_attack_3.tscn')
var interval_between_attacks = 6
var time_since_last_attack = 3
var max_health = 30
var current_health = 30
@onready var boss_health_bar: ProgressBar = $BossHealthBar

func _ready() -> void:
	boss_health_bar.max_value = max_health
	boss_health_bar.value = current_health
	var screen_size = get_viewport_rect().size
	self.position.x = screen_size.x /2

func _process(delta: float) -> void:
	var screen_size = get_viewport_rect().size
	self.position.x = screen_size.x /2
	time_since_last_attack += delta
	if time_since_last_attack >= interval_between_attacks:
		random_attack_start()
		time_since_last_attack = 0
	if current_health <= 0:
		death()
	var boss = get_tree().get_first_node_in_group("boss")
	if boss:
		if ($RayCast2D.is_colliding() ):
			boss.take_damage()
		
		
		queue_free()
	if Input.is_key_pressed(KEY_F):
		
		take_damage()
		

func random_attack_start() -> void:
	var attacks = [attack_1, attack_2, attack_3]
	var chosen = attacks.pick_random()
	var instance = chosen.instantiate()
	instance.position = self.position
	get_parent().add_child(instance)
	
func take_damage(damage = 1):
	current_health -= damage
	boss_health_bar.value = current_health
	
func death():
	#put death text and link to finish story here and remove queue_free()
	queue_free()
	
