extends Node2D
class_name Tilemap

@onready var tilemap: TileMapLayer = $Main

var houses_direction_atlas_map = {
	Vector2i.RIGHT: Vector2i(10,1),
	Vector2i.LEFT: Vector2i(11,1),
	Vector2i.UP: Vector2i(10,0),
	Vector2i.DOWN: Vector2i(11,0),
}
var houses: Array
var deliveries: Dictionary = {}

func _ready():
#	TODO generate map
#	TEST adding roads with terrain logic
	#tilemap.set_cells_terrain_connect(
		#[
			#Vector2i(-1,-1),
			#Vector2i(-1,-2),
			#Vector2i(-1,-3),
			#Vector2i(-2,-3),
		#],
		#0,
		#0
	#)
	
	for c in houses_direction_atlas_map.values():
		houses.append_array(tilemap.get_used_cells_by_id(2, c))
	for h in houses:
		deliveries[h] = false
	generate_houses_direction()

func deliver_newspaper(house_coords: Vector2i):
	if houses.has(house_coords):
		deliveries[house_coords] = true

func generate_houses_direction():
	for h in houses:
		var roads: Array = []
		for tile_coords in tilemap.get_surrounding_cells(h):
			var data: TileData = tilemap.get_cell_tile_data(tile_coords)
			if data and data.get_custom_data("road"):
				roads.append(tile_coords)
		var road_coords = roads.pick_random()
		var direction_vector = road_coords - h
		tilemap.set_cell(h, 2, houses_direction_atlas_map[direction_vector])

func get_tile_by_coords(coords: Vector2i) -> Dictionary:
	var data: TileData = tilemap.get_cell_tile_data(coords)
	return {
		"road": data.get_custom_data("road") if data else false,
		"land_block": data.get_custom_data("land_block") if data else true,
		"inaccessable": data.get_custom_data("inaccessable") if data else true,
		"house_up": data.get_custom_data("house_up") if data else false,
		"house_right": data.get_custom_data("house_right") if data else false,
		"house_down": data.get_custom_data("house_down") if data else false,
		"house_left": data.get_custom_data("house_left") if data else false,
	}
