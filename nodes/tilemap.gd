extends Node2D
class_name Tilemap

signal delivery_done
signal all_deliveries_done

@onready var tilemap: TileMapLayer = $Main
@onready var colours: TileMapLayer = $Colours

var houses: Array
var deliveries: Dictionary = {}

var houses_direction_atlas_map = {
	Vector2i.RIGHT: Vector2i(10,1),
	Vector2i.LEFT: Vector2i(11,1),
	Vector2i.UP: Vector2i(10,0),
	Vector2i.DOWN: Vector2i(11,0),
}

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

func get_delivery_count():
	var count := 0
	for d in deliveries.values():
		if d == true:
			count += 1
	return count

func try_deliver_newspaper(house_coords: Vector2i, house_data: Dictionary, van_direction: Vector2i) -> bool:
	if !tile_is_house(house_data):
		return false
	if !houses.has(house_coords):
		return false
	if deliveries[house_coords] == true:
		return false
	var deliver_successful := false
	match(van_direction):
		Vector2i.LEFT:
			if house_data["house_right"]:
				deliver_successful = true
		Vector2i.RIGHT:
			if house_data["house_left"]:
				deliver_successful = true
		Vector2i.UP:
			if house_data["house_down"]:
				deliver_successful = true
		Vector2i.DOWN:
			if house_data["house_up"]:
				deliver_successful = true
	if deliver_successful:
		deliveries[house_coords] = true
		colours.set_cell(house_coords, 0, Vector2i(0, 1))
	if get_delivery_count() == deliveries.size():
		all_deliveries_done.emit()
	delivery_done.emit()
	return deliver_successful

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

func tile_is_house(tile_data: Dictionary) -> bool:
	return tile_data["house_left"] or tile_data["house_up"] or tile_data["house_right"] or tile_data["house_down"]
	
