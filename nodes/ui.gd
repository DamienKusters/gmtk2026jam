extends Control
class_name Ui

@onready var tilemap: Tilemap = $"../../Tilemap"
@onready var van: Van = $"../../Van"
@onready var camera = $"../../Camera2D"
@onready var cursor = $"../../VanCursor"

@onready var pregame := true :
	set(value):
		pregame = value
		update_ui(value)

func _ready() -> void:
	tilemap.all_deliveries_done.connect(all_deliveries_done)
	van.quota_timer_reset.connect(_animate_quota_timer)
	van.quota_timer_depleted.connect(quota_timer_depleted)
	update_ui(pregame)

func _process(_delta: float) -> void:
	if !pregame:
		return
	var mouse_pos = camera.get_global_mouse_position() - tilemap.position
	var tilemap_coords = tilemap.starting_positions.local_to_map(mouse_pos)
	var cell_data = tilemap.starting_positions.get_cell_tile_data(tilemap_coords)
	var cell_valid = true if cell_data and cell_data.get_custom_data("valid") else false
	
	if cell_valid:
		cursor.position = tilemap_coords * 128
		if Input.is_action_just_pressed("select"):
			van.start(tilemap.tilemap.local_to_map(mouse_pos), cursor.position)
			pregame = false

func update_ui(_pregame = false):
	cursor.visible = _pregame
	if tilemap.starting_positions:
		tilemap.starting_positions.visible = _pregame
	%ProgressBar.visible = !_pregame
	%StartingPosLabel.visible = _pregame

func all_deliveries_done():
	$VBoxContainer/Padding/GameWon.visible = true

func quota_timer_depleted():
	$VBoxContainer/Padding/GameOver.visible = true

var quota_tween: Tween
func _animate_quota_timer(timeout: float):
	%ProgressBar.value = timeout
	quota_tween = Globals.animate(quota_tween, self)
	quota_tween.tween_property(%ProgressBar,
		"value", 0, timeout).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
