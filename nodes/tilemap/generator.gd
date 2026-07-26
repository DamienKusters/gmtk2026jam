extends TileMapLayer

const TOP_LEFT_COORDS: Vector2i = Vector2(1,1)
@onready var top_left_patterns = [
	self.tile_set.get_pattern(0),
	self.tile_set.get_pattern(1),
	self.tile_set.get_pattern(2),
]

const TOP_MIDDLE_COORDS: Vector2i = Vector2(4,1)
@onready var top_middle_patterns = [
	self.tile_set.get_pattern(3),
	self.tile_set.get_pattern(4),
]

const TOP_RIGHT_COORDS: Vector2i = Vector2(6,1)
@onready var top_right_patterns = [
	self.tile_set.get_pattern(5),
	#self.tile_set.get_pattern(6),#replaced by 11
	self.tile_set.get_pattern(11),
]

const BOT_LEFT_COORDS: Vector2i = Vector2(1,3)
@onready var bot_left_patterns = [
	self.tile_set.get_pattern(7),
	self.tile_set.get_pattern(8),
	#self.tile_set.get_pattern(12), # annoying
	self.tile_set.get_pattern(13),
]

const BOT_RIGHT_COORDS: Vector2i = Vector2(5,3)
@onready var bot_right_patterns = [
	self.tile_set.get_pattern(9),
	self.tile_set.get_pattern(10),
	self.tile_set.get_pattern(14),
	self.tile_set.get_pattern(15),
]

var road_cells = [
	Vector2i(0,0),
	Vector2i(1,0),
	Vector2i(2,0),
	Vector2i(0,1),
	Vector2i(1,1),
	Vector2i(2,1),
	
	Vector2i(4,2),
	Vector2i(4,3),
	Vector2i(5,2),
	Vector2i(5,3),
	
	Vector2i(8,2),
	Vector2i(8,3),
	Vector2i(9,2),
	Vector2i(9,3),
	
	Vector2i(9,0)
]

func _ready():
	generate_map()
	
func generate_map():
	set_pattern(TOP_LEFT_COORDS, top_left_patterns.pick_random())
	set_pattern(TOP_MIDDLE_COORDS, top_middle_patterns.pick_random())
	set_pattern(TOP_RIGHT_COORDS, top_right_patterns.pick_random())
	set_pattern(BOT_LEFT_COORDS, bot_left_patterns.pick_random())
	set_pattern(BOT_RIGHT_COORDS, bot_right_patterns.pick_random())
	
	var cells = []
	for r in road_cells:
		cells.append_array(get_used_cells_by_id(2, r))
	
	set_cells_terrain_connect(cells, 0, 0)
