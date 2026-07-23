extends Control
class_name Ui

@onready var tilemap: Tilemap = $"../../Tilemap"
@onready var van: Van = $"../../Van"

func _ready() -> void:
	tilemap.delivery_done.connect(delivery_done)
	tilemap.all_deliveries_done.connect(all_deliveries_done)
	van.quota_timer_reset.connect(_animate_quota_timer)
	van.quota_timer_depleted.connect(quota_timer_depleted)

func delivery_done():
	$VBoxContainer/NinePatchTopCut/MarginContainer/HBoxContainer/Label.text = "{0}/{1} deliveries".format([
		tilemap.get_delivery_count(),
		tilemap.deliveries.size()
	])
	
func all_deliveries_done():
	$VBoxContainer/Padding/GameWon.visible = true

func quota_timer_depleted():
	$VBoxContainer/Padding/GameOver.visible = true

var quota_tween: Tween
func _animate_quota_timer(timeout: float):
	$VBoxContainer/NinePatchTopCut/MarginContainer/HBoxContainer/ProgressBar.value = timeout
	quota_tween = Globals.animate(quota_tween, self)
	quota_tween.tween_property($VBoxContainer/NinePatchTopCut/MarginContainer/HBoxContainer/ProgressBar,
		"value", 0, timeout).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
