extends Node2D
class_name Tilemap

@onready var tilemap: TileMapLayer = $Main

var houses_atlas_coords = [
	Vector2i(10,0),
	Vector2i(10,1),
	Vector2i(11,0),
	Vector2i(11,1),
]
var houses: Array

func _ready():
#	TODO generate map
#	TEST adding roads with terrain logic
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
	
	for c in houses_atlas_coords:
		houses.append_array(tilemap.get_used_cells_by_id(2, c))
	pass

func get_tile_by_coords(coords: Vector2i) -> Dictionary:
	var data: TileData = tilemap.get_cell_tile_data(coords)
	return {
		"land_block": data.get_custom_data("land_block") if data else true,
		"inaccessable": data.get_custom_data("inaccessable") if data else true,
		"house_up": data.get_custom_data("house_up") if data else false,
		"house_right": data.get_custom_data("house_right") if data else false,
		"house_down": data.get_custom_data("house_down") if data else false,
		"house_left": data.get_custom_data("house_left") if data else false,
	}
