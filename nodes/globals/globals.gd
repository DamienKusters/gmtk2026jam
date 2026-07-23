extends Node

var money := 0

func animate(tween: Tween, parent: Node):
	if tween:
		tween.kill()
	return parent.create_tween()
