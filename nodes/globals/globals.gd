extends Node

signal money_updated

enum UpgradeEnum { BOY, PROPAGANDA, HELI }
var upgrades: Dictionary[UpgradeEnum, int] = {}

var money := 0 : 
	set(value):
		money = value
		money_updated.emit()

func animate(tween: Tween, parent: Node):
	if tween:
		tween.kill()
	return parent.create_tween()
