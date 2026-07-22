extends Node2D

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
