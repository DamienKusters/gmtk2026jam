extends TextureRect

@export var upgrade: Globals.UpgradeEnum

var uses := 0
var toggled := false : 
	set(value):
		toggled = value
		$TextureRect.visible = value

func _ready():
	Globals.van_used_ability.connect(update_info)
#	TODO run update_info when game starts
	_initialize()

func update_info(van: Van, _upgrade: Globals.UpgradeEnum):
	if upgrade != _upgrade:
		return
	match (_upgrade):
		Globals.UpgradeEnum.BOY:
			$VBoxContainer2/Label.text = "ready" if van.shot_ready else ""
		Globals.UpgradeEnum.PROPAGANDA:
			pass # TODO
		Globals.UpgradeEnum.HELI:
			toggled = van.flying
			$VBoxContainer2/Label.text = str(Globals.upgrades[Globals.UpgradeEnum.HELI] - van.ascends)

func _initialize():
	match (upgrade):
		Globals.UpgradeEnum.BOY:
			texture = load("res://nodes/ui/popups/upgrades/boy.png")
			$VBoxContainer2/TextureRect.texture = load("res://nodes/ui/ui_input_atlas/one.tres")
			visible = Globals.upgrades.has(Globals.UpgradeEnum.BOY)
		Globals.UpgradeEnum.PROPAGANDA:
			texture = load("res://nodes/ui/popups/upgrades/propaganda.png")
			$VBoxContainer2/TextureRect.texture = load("res://nodes/ui/ui_input_atlas/two.tres")
			visible = Globals.upgrades.has(Globals.UpgradeEnum.PROPAGANDA)
		Globals.UpgradeEnum.HELI:
			texture = load("res://nodes/ui/popups/upgrades/helicopter.png")
			$VBoxContainer2/TextureRect.texture = load("res://nodes/ui/ui_input_atlas/three.tres")
			visible = Globals.upgrades.has(Globals.UpgradeEnum.HELI)
