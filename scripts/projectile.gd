extends Area2D

@export var speed = 500
var direction = Vector2.UP

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta
	$AnimatedSprite2D.play()
	$AnimatedSprite2D.rotate(10)
	if not get_viewport().get_visible_rect().has_point(global_position):
		queue_free()
		
	var boss = get_tree().get_first_node_in_group("boss")
	if boss:
		if ($RayCast2D.is_colliding() ):
			boss.take_damage()
	
