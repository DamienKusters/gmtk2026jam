extends Node2D
class_name PropagandaComponent

@onready var van: Van = get_parent()

func deliver_in_range(coords: Vector2i):
	var surrounding_tiles = [
		coords + Vector2i.LEFT,
		coords + Vector2i.RIGHT,
		coords + Vector2i.UP,
		coords + Vector2i.DOWN,
		
		coords + Vector2i.LEFT + Vector2i.UP,
		coords + Vector2i.LEFT + Vector2i.DOWN,
		coords + Vector2i.RIGHT + Vector2i.UP,
		coords + Vector2i.RIGHT + Vector2i.DOWN,
	]
	
	for t in surrounding_tiles:
		var tile = van.tilemap.get_tile_by_coords(t)
		if van.tilemap.try_deliver_newspaper(t, tile, Vector2i.ZERO, true):
			van.reset_quota_timer()
