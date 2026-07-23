extends Node2D

var direction: Vector2i = Vector2i.RIGHT
var location_normalized: Vector2i

var move_length := 128

const quota_timeout = 4

var directions_atlas_map = {
	Vector2i.RIGHT: Rect2(0,0,128,128),
	Vector2i.LEFT: Rect2(128,0,128,128),
	Vector2i.UP: Rect2(128,128,128,128),
	Vector2i.DOWN: Rect2(0,128,128,128),
}

@onready var sprite = $Sprite2D

# TODO dependency
@onready var tilemap: Tilemap = $"../Tilemap"

func _ready() -> void:
	_set_texture_direction(direction)
	_label_set_text(str(quota_timeout))
	_animate_timer_label()
	$QuotaTimer.wait_time = quota_timeout
	$QuotaTimer.start()
	tilemap.all_deliveries_done.connect(win_game)

func _process(_delta: float) -> void:
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
	var atlas: AtlasTexture = sprite.texture
	atlas.region = directions_atlas_map[key]

func _on_timer_timeout() -> void:
	var next_tile_coords = location_normalized + direction
	var next_tile = tilemap.get_tile_by_coords(next_tile_coords)
	if tilemap.try_deliver_newspaper(next_tile_coords, next_tile, direction):
		$QuotaTimer.start()
		_label_set_text(str(quota_timeout))
		_animate_timer_label()
		$"../CanvasLayer/Ui/VBoxContainer/NinePatchTopCut/MarginContainer/HBoxContainer/ProgressBar".value = quota_timeout
		$"../CanvasLayer/Ui/VBoxContainer/NinePatchTopCut/MarginContainer/HBoxContainer/Label".text = "{0}/{1} deliveries".format([
			tilemap.get_delivery_count(),
			tilemap.deliveries.size()
		])
	if next_tile["inaccessable"] or next_tile["land_block"]:
		return
	location_normalized = next_tile_coords
	_animate_move(location_normalized * move_length)

var move_tween: Tween
func _animate_move(new_position: Vector2):
	move_tween = Globals.animate(move_tween, self)
	move_tween.tween_property(self, "position", new_position, $Timer.wait_time)

func win_game():
	$QuotaTimer.stop()
	push_error("Game won")

func _on_quota_timer_timeout() -> void:
	push_error("Game over")

var label_tween: Tween
func _animate_timer_label():
	label_tween = Globals.animate(label_tween, self)
	label_tween.parallel().tween_method(_label_set_text, $Label.text, "0", quota_timeout)
	label_tween.parallel().tween_property($"../CanvasLayer/Ui/VBoxContainer/NinePatchTopCut/MarginContainer/HBoxContainer/ProgressBar",
		"value", 0, quota_timeout).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _label_set_text(text: String):
	$Label.text = text
