extends VBoxContainer

signal window_closed

func update_content():
	Globals.money_updated.connect(func(): $HBoxContainer/Label.text = str(Globals.money))
	$HBoxContainer/Label.text = str(Globals.money)
	%BoyUpgrade.upgrade_upgraded.connect(func(): _sync_upgrade_to_global(%BoyUpgrade, &"boy"))
	%PrpUpgrade.upgrade_upgraded.connect(func(): _sync_upgrade_to_global(%PrpUpgrade, &"prp"))
	%HelUpgrade.upgrade_upgraded.connect(func(): _sync_upgrade_to_global(%HelUpgrade, &"hel"))

func _sync_upgrade_to_global(upgrade: UpgradeButton, key: StringName):
	Globals.upgrades[key] = upgrade

func _on_continue_pressed() -> void:
	window_closed.emit()

func _on_quit_pressed() -> void:
	get_tree().quit()
