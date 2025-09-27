extends CanvasLayer
var hits = 0
@onready var hit_label: Label = $Signatures

func add_hit() -> void:
	hits += 1
	hit_label.text = "Hits %d" % hits
