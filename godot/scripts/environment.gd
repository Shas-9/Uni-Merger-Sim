extends TileMapLayer


@onready var tile_map_layer: TileMapLayer = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(tile_map_layer.get_used_cells_by_id(1))
	#tile_map_layer.clear()
	await get_tree().create_timer(2).timeout
	var pattern = create_pattern()
	# You can add it to the TileSet if you want, it's not needed
	var pattern_idx = tile_map_layer.tile_set.add_pattern(pattern)
	tile_map_layer.set_pattern(Vector2i(10, 10), pattern)

func create_pattern() -> TileMapPattern:
	var pattern = TileMapPattern.new()
	pattern.set_size(Vector2i(2, 2))
	for col in 2:
		for row in 2:
			pattern.set_cell(Vector2i(col, row), 0, Vector2i(col+5, row+5), 0)

	return pattern

func get_clicked_tile_power():
	var clicked_cell = tile_map_layer.local_to_map(tile_map_layer.get_local_mouse_position())
	var data = tile_map_layer.get_cell_tile_data(clicked_cell)
	print(data)
	if data:
		return data.get_custom_data("power")
	else:
		return 0
