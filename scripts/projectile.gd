extends Area2D
@onready var player: Node2D = get_tree().get_first_node_in_group("Player")
@export var speed = 500
var direction = Vector2.UP
var cooldown = 1
var current_cooldown = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.add_hit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_cooldown -= delta
	position += direction * speed * delta
	$AnimatedSprite2D.play()
	$AnimatedSprite2D.rotate(10)
	if not get_viewport().get_visible_rect().has_point(global_position):
		queue_free()
	
	var boss = get_tree().get_first_node_in_group("boss")
	if boss:
		if ($RayCast2D.is_colliding() && current_cooldown <= 0):
			queue_free()
			boss.take_damage()
			current_cooldown = cooldown
			
			
	
