extends Node2D
class_name Tilemap

@onready var tilemap: TileMapLayer = $Main

func _ready():
#	TEST
	tilemap.set_cells_terrain_connect(
		[
			Vector2i(-1,-1),
			Vector2i(-1,-2),
			Vector2i(-1,-3),
			Vector2i(-2,-3),
		],
		0,
		0
	)

func get_tile_by_coords(coords: Vector2i) -> Dictionary:
	var data: TileData = tilemap.get_cell_tile_data(coords)
	return {
		"land_block": data.get_custom_data("land_block") if data else true,
		"inaccessable": data.get_custom_data("inaccessable") if data else true
	}
