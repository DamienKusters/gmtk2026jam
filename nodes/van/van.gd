extends Node2D
class_name Van

signal quota_timer_reset(wait_time: float)
signal quota_timer_depleted

const MOVE_LENGTH := 128
const QUOTA_TIMEOUT = 2

var movement_enabled := true
var game_ended := false
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
	_set_texture_direction(direction)
	$QuotaTimer.wait_time = QUOTA_TIMEOUT
	$QuotaTimer.start()
	quota_timer_reset.emit(QUOTA_TIMEOUT)
	tilemap.all_deliveries_done.connect(all_deliveries_done)

func _process(_delta: float) -> void:
	if movement_enabled:
		var new_direction = determine_user_direction()
		set_direction(new_direction)

func determine_user_direction() -> Vector2i:
	return Input.get_vector("left", "right", "up", "down").normalized()

func set_direction(_direction: Vector2i) -> bool:
	if _direction in [Vector2i.UP,Vector2i.RIGHT,Vector2i.LEFT,Vector2i.DOWN]:
		direction = _direction
		_set_texture_direction(_direction)
		return true
	return false

func _set_texture_direction(key: Vector2i):
	var atlas: AtlasTexture = $Sprite2D.texture
	atlas.region = directions_atlas_map[key]

func _on_timer_timeout() -> void:
	if game_ended:
		return
	var next_tile_coords = location_normalized + direction
	var next_tile = tilemap.get_tile_by_coords(next_tile_coords)
	if tilemap.try_deliver_newspaper(next_tile_coords, next_tile, direction):
		$QuotaTimer.start()
		quota_timer_reset.emit(QUOTA_TIMEOUT)

	if next_tile["inaccessable"] or next_tile["land_block"]:
		return
	location_normalized = next_tile_coords
	_animate_move(location_normalized * MOVE_LENGTH)

var move_tween: Tween
func _animate_move(new_position: Vector2):
	move_tween = Globals.animate(move_tween, self)
	move_tween.tween_property(self, "position", new_position, $Timer.wait_time)

func all_deliveries_done():
	movement_enabled = false
	game_ended = true
	$QuotaTimer.stop()

func _on_quota_timer_timeout() -> void:
	if game_ended:
		return
	quota_timer_depleted.emit()
	movement_enabled = false
	game_ended = true
