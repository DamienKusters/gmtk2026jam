extends Node2D
class_name Van

signal quota_timer_reset(wait_time: float)
signal quota_timer_depleted

const MOVE_LENGTH := 128
const QUOTA_TIMEOUT: float = 7
const QUOTA_TIME_DECREASE: float = .5
const QUOTA_MINUMUM_TIME: float = .5

var movement_enabled := false
var game_ended := true
var direction: Vector2i = Vector2i.RIGHT
var location_normalized: Vector2i = Vector2i(0, 1)

var directions_atlas_map = {
	Vector2i.RIGHT: Rect2(0,0,128,128),
	Vector2i.LEFT: Rect2(128,0,128,128),
	Vector2i.UP: Rect2(128,128,128,128),
	Vector2i.DOWN: Rect2(0,128,128,128),
}

# TODO dependency
@onready var tilemap: Tilemap = $"../Tilemap"

func _ready() -> void:
	tilemap.all_deliveries_done.connect(all_deliveries_done)
	_set_texture_direction(direction)
	visible = false

func _process(_delta: float) -> void:
	if movement_enabled:
		var new_direction = determine_user_direction()
		if set_direction(new_direction) and move_blocked:
			$Timer.start()
			_on_timer_timeout()

func start(_tile_coords: Vector2i, _node_position: Vector2i):
	location_normalized = _tile_coords
	position = _node_position
	_set_texture_direction(direction) # TODO towards road
	var time = _get_quota_timeout()
	$QuotaTimer.wait_time = time
	$QuotaTimer.start()
	$Timer.start()
	quota_timer_reset.emit(time)
	movement_enabled = true
	game_ended = false
	visible = true
	_on_timer_timeout()

func determine_user_direction() -> Vector2i:
	return Input.get_vector("left", "right", "up", "down").normalized()

func set_direction(_direction: Vector2i) -> bool:
	if (direction != _direction) and _direction in [Vector2i.UP,Vector2i.RIGHT,Vector2i.LEFT,Vector2i.DOWN]:
		direction = _direction
		_try_deliver_newspaper()
		_set_texture_direction(_direction)
		return true
	_try_deliver_newspaper() # TODO, visually this looks weird because of the tweening but it is responsive
	return false

func _try_deliver_newspaper():
	var next_tile_coords = location_normalized + direction
	var next_tile = tilemap.get_tile_by_coords(next_tile_coords)
	if tilemap.try_deliver_newspaper(next_tile_coords, next_tile, direction):
		var timeout = _get_quota_timeout()
		$QuotaTimer.start(timeout)
		quota_timer_reset.emit(timeout)

func _set_texture_direction(key: Vector2i):
	var atlas: AtlasTexture = $Sprite2D.texture
	atlas.region = directions_atlas_map[key]

var move_blocked := false
func _on_timer_timeout() -> void:
	if game_ended:
		return
	var next_tile_coords = location_normalized + direction
	var next_tile = tilemap.get_tile_by_coords(next_tile_coords)
	_try_deliver_newspaper()

	if next_tile["inaccessable"] or next_tile["land_block"]:
		move_blocked = true
		return
	move_blocked = false
	location_normalized = next_tile_coords
	_animate_move(location_normalized * MOVE_LENGTH)
	$"../VanDebugLocation".position = location_normalized * MOVE_LENGTH

func _get_quota_timeout() -> float:
	var time = QUOTA_TIMEOUT - (tilemap.get_delivery_count() * QUOTA_TIME_DECREASE)
	return time if time > QUOTA_MINUMUM_TIME else QUOTA_MINUMUM_TIME

var move_tween: Tween
func _animate_move(new_position: Vector2):
	move_tween = Globals.animate(move_tween, self)
	move_tween.tween_property(self, "position", new_position, $Timer.wait_time)

func all_deliveries_done():
	movement_enabled = false
	game_ended = true
	$QuotaTimer.stop()
	$Timer.stop()
	visible = false

func _on_quota_timer_timeout() -> void:
	if game_ended:
		return
	quota_timer_depleted.emit()
	movement_enabled = false
	game_ended = true
	visible = false
	
