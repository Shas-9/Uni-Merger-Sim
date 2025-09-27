extends Node2D

@export var tilemap: TileMapLayer
@export var json_path: String = "res://data/tilemap.json"

@export var tile_set_map := {  # map color → tile ID
	Color(1, 1, 1): 0,  # white → tile 0
	Color(0, 0, 0): 1,  # black → tile 1
}

func _ready() :
	
	if tilemap == null:
		push_error("TileMapLayer not assigned!")
		return

	var grid = load_json(json_path)
	if grid.size() == 0:
		push_error("Empty grid!")
		return

	populate_tilemap(grid)

func load_json(path: String) -> Array:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Could not open JSON: " + path)
		return []
	var text = file.get_as_text()
	file.close()
	return JSON.parse_string(text)

func map_tiles(json_value):
	if json_value == 0:
		return Vector2i(2, 14)
	if json_value == 1:
		return Vector2i(-1, -1)
	if json_value == 2:
		return Vector2i(2, 10)
	if json_value == 3:
		return Vector2i(7, 14)
	if json_value == 4:
		return Vector2i(15, 3)
	return Vector2i(-1, -1)

func populate_tilemap(grid: Array):
	for y in range(grid.size()):
		var row = grid[y]
		for x in range(row.size()):
			var tile_id = row[x]
			if tile_id != null:
				tilemap.set_cell(Vector2i(x, y), 0, map_tiles(tile_id))
