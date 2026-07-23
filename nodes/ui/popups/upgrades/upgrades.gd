extends VBoxContainer

signal window_closed

func _ready() -> void:
	%BoyUpgrade.upgrade_level = Globals.upgrades[Globals.UpgradeEnum.BOY] if Globals.upgrades.has(Globals.UpgradeEnum.BOY) else 0
	%PrpUpgrade.upgrade_level = Globals.upgrades[Globals.UpgradeEnum.PROPAGANDA] if Globals.upgrades.has(Globals.UpgradeEnum.PROPAGANDA) else 0
	%HelUpgrade.upgrade_level = Globals.upgrades[Globals.UpgradeEnum.HELI] if Globals.upgrades.has(Globals.UpgradeEnum.HELI) else 0

func update_content():
	Globals.money_updated.connect(func(): $HBoxContainer/Label.text = str(Globals.money))
	$HBoxContainer/Label.text = str(Globals.money)
	%BoyUpgrade.upgrade_upgraded.connect(func(): _sync_upgrade_to_global(%BoyUpgrade.upgrade_level, Globals.UpgradeEnum.BOY))
	%PrpUpgrade.upgrade_upgraded.connect(func(): _sync_upgrade_to_global(%PrpUpgrade.upgrade_level, Globals.UpgradeEnum.PROPAGANDA))
	%HelUpgrade.upgrade_upgraded.connect(func(): _sync_upgrade_to_global(%HelUpgrade.upgrade_level, Globals.UpgradeEnum.HELI))

func _sync_upgrade_to_global(level: int, key: Globals.UpgradeEnum):
	Globals.upgrades[key] = level

func _on_continue_pressed() -> void:
	window_closed.emit()

func _on_quit_pressed() -> void:
	get_tree().quit()
