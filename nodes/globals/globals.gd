extends Node

signal money_updated
signal van_used_ability(van: Van, upgrade: UpgradeEnum)

enum UpgradeEnum { BOY, PROPAGANDA, HELI }
var upgrades: Dictionary[UpgradeEnum, int] = {
	#UpgradeEnum.BOY: 1,
	#UpgradeEnum.PROPAGANDA: 1,
	#UpgradeEnum.HELI: 1,
}

var money := 0 : 
	set(value):
		money = value
		money_updated.emit()

func animate(tween: Tween, parent: Node):
	if tween:
		tween.kill()
	return parent.create_tween()
