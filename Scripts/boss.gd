extends Node2D

var bullet_scene = load('res://Scenes/bullet.tscn')

func _process(delta: float) -> void:
	rotate(.5)
	var b = bullet_scene.instantiate()
	b.position = self.position
	b.rotation = self.rotation
	get_parent().add_child(b)
