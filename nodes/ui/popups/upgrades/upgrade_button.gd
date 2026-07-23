extends TextureRect
class_name UpgradeButton

signal upgrade_upgraded

@export var upgrade_name: String
@export var upgrade_description: String
@export var upgrade_icon: Texture2D

@export var upgrade_level := 0
@export var upgrade_max_level := 1

@export var upgrade_base_price := 10
@export var upgrade_percentage_increase := 10

func _ready():
	refresh()

func refresh():
	$MarginContainer/VBoxContainer/Label.text = upgrade_name
	$MarginContainer/VBoxContainer/Label2.text = upgrade_description
	$MarginContainer/VBoxContainer/ColorRect/TextureRect.texture = upgrade_icon
	$MarginContainer/VBoxContainer/Buttons/Buy.visible = upgrade_level <= 0
	$MarginContainer/VBoxContainer/Buttons/Upgrade.visible = true if upgrade_level > 0 and upgrade_level < upgrade_max_level else false
	$Label.text = "Level: {0}\nCost: {1}".format([upgrade_level + 1, get_next_level_cost()]) if upgrade_level < upgrade_max_level else ""
	$MarginContainer/VBoxContainer/ColorRect/LvlLabel.text = "Level: {0}".format([upgrade_level]) if upgrade_level > 0 else ""

func get_next_level_cost() -> int:
	var level := upgrade_level + 1
	var multiplier := pow(1.0 + upgrade_percentage_increase / 100.0, level - 1)
	return roundi(upgrade_base_price * multiplier)

func is_bought() -> bool:
	return upgrade_level > 0

func _on_buy_pressed() -> void:
	_upgrade()

func _on_upgrade_pressed() -> void:
	_upgrade()

func _upgrade():
	var cost = get_next_level_cost()
	if Globals.money >= cost:
		Globals.money -= cost
		upgrade_level += 1
		upgrade_upgraded.emit()
		refresh()
	
