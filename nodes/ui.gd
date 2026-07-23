extends Control
class_name Ui

const DELIVERY_REWARD := 10
const TILE_WIDTH := 128

@onready var tilemap: Tilemap = $"../../Tilemap"
@onready var van: Van = $"../../Van"
@onready var camera = $"../../Camera2D"
@onready var cursor = $"../../VanCursor"

@onready var pregame := true :
	set(value):
		pregame = value
		update_ui(value)

func _ready() -> void:
	%GameResults.window_closed.connect(func(): _open_menu(false))
	%Upgrades.window_closed.connect(func(): get_tree().reload_current_scene())
	tilemap.all_deliveries_done.connect(game_over)
	van.quota_timer_reset.connect(_animate_quota_timer)
	van.quota_timer_depleted.connect(game_over)
	_reset_game()

func _process(_delta: float) -> void:
	if !pregame:
		return
	var mouse_pos = camera.get_global_mouse_position() - tilemap.position
	var tilemap_coords = tilemap.starting_positions.local_to_map(mouse_pos)
	var cell_data = tilemap.starting_positions.get_cell_tile_data(tilemap_coords)
	var cell_valid = true if cell_data and cell_data.get_custom_data("valid") else false
	
	if cell_valid:
		cursor.position = tilemap_coords * TILE_WIDTH
		if Input.is_action_just_pressed("select"):
			tilemap_position = tilemap_coords
			node_position = tilemap_coords * TILE_WIDTH
			pregame = false
			_animate_countdown()
			%PregameCountdown.start()

func update_ui(_pregame = false):
	if tilemap.starting_positions:
		tilemap.starting_positions.visible = _pregame
	%ProgressBar.visible = !_pregame
	%CountDown.visible = !_pregame
	%StartingPosLabel.visible = _pregame

func game_over():
	var money_reward = calculate_money_reward(tilemap.get_delivery_count())
	Globals.money += money_reward
	%GameResults.update_content(
		tilemap.get_delivery_count(),
		tilemap.deliveries.size(),
		DELIVERY_REWARD,
		money_reward
	)
	_open_menu(true)

func calculate_money_reward(deliveries_done: int) -> int:
	@warning_ignore("integer_division")
	return deliveries_done * (2 * DELIVERY_REWARD + deliveries_done - 1) / 2

func _reset_game():
	cursor.visible = true
	pregame = true
	%Popup.visible = false
	update_ui(pregame)

func _open_menu(is_results = true):
	%Popup.visible = true
	%GameResults.visible = is_results
	%Upgrades.visible = !is_results
	if !is_results:
		%Upgrades.update_content()

var quota_tween: Tween
func _animate_quota_timer(timeout: float):
	%ProgressBar.value = timeout
	quota_tween = Globals.animate(quota_tween, self)
	quota_tween.tween_property(%ProgressBar,
		"value", 0, timeout).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

var tilemap_position: Vector2i
var node_position: Vector2i
func _on_pregame_countdown_timeout() -> void:
	cursor.visible = false
	%PregameCountdownLabel.visible = false
	van.start(tilemap_position, node_position)

var countdown_tween: Tween
func _animate_countdown():
	%PregameCountdownLabel.visible = true
	%PregameCountdownLabel.text = str(int(%PregameCountdown.wait_time))
	countdown_tween = Globals.animate(countdown_tween, self)
	countdown_tween.tween_method(func(_text): %PregameCountdownLabel.text = _text, %PregameCountdownLabel.text, "0", %PregameCountdown.wait_time)
	countdown_tween.tween_property(%PregameCountdownLabel, "visible", false, 0)
