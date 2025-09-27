extends CanvasLayer

var hits: int = 100
var _ending := false
@onready var hit_label: Label = $Signatures

func _ready() -> void:
	hit_label.text = "Hits: %d" % hits

func add_hit() -> void:
	if _ending: return
	hits -= 1
	hit_label.text = "Hits: %d" % hits
	if hits <= 0:
		_ending = true
		# (optional) clean up bullets so they stop processing
		get_tree().call_group_flags(SceneTree.GROUP_CALL_DEFERRED, "projectiles", "queue_free")
		# defer the scene change so it happens outside the current frame
		call_deferred("_go_to_bad_end")

func _go_to_bad_end() -> void:
	get_tree().change_scene_to_file("res://DevlynScenes/bad_end_screen.tscn")  # check exact path
