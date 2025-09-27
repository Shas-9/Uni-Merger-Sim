extends Area2D

signal hit

@export var projectile_scene: PackedScene
@export var speed = 400
@export var dash_speed = 1200
@export var dash_duration = 0.2
@export var dash_cooldown = 0.5

var is_dashing = false
var dash_time_left = 0.0
var dash_cooldown_left = 0.0
var dash_direction = Vector2.ZERO
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$DetectionArea.body_entered.connect(_on_detection_area_body_entered)
	$DetectionArea.body_exited.connect(_on_detection_area_body_exited)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_just_pressed("throw_projectile"):
		throw_projectile()

	# Dash logic
	if dash_cooldown_left > 0:
		dash_cooldown_left -= delta

	if is_dashing:
		dash_time_left -= delta
		if dash_time_left > 0:
			velocity = dash_direction * dash_speed
		else:
			is_dashing = false
			dash_cooldown_left = dash_cooldown
	else:
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$AnimatedSprite2D.play()
			# Start dash if space is pressed and not cooling down
			if Input.is_action_just_pressed("dash") and dash_cooldown_left <= 0:
				is_dashing = true
				dash_time_left = dash_duration
				dash_direction = velocity.normalized()
		else:
			$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk_left"
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.flip_h = velocity.x > 0
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "walk_back"
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = "walk_front"

func throw_projectile():
	var projectile = projectile_scene.instantiate()
	projectile.position = position
	get_parent().add_child(projectile)
	projectile.direction = Vector2.UP

func _on_detection_area_body_entered(body):
	if body.is_in_group("npcs"):
		print("npc entered")
		body.stop_movement()

func _on_detection_area_body_exited(body):
	if body.is_in_group("npcs"):
		body.resume_movement()
