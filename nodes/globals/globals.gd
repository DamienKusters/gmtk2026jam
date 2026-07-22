extends Node

func animate(tween: Tween, parent: Node):
	if tween:
		tween.kill()
	return parent.create_tween()
