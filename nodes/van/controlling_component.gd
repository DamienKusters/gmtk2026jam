extends Node
class_name ControllingComponent

var user_direction: Vector2i

func get_user_direction() -> Vector2i:
	var inputs = {
		Vector2i.LEFT: Input.is_action_just_pressed("left"),
		Vector2i.RIGHT: Input.is_action_just_pressed("right"),
		Vector2i.UP: Input.is_action_just_pressed("up"),
		Vector2i.DOWN: Input.is_action_just_pressed("down"),
	}
	for input_key in inputs:
		var input_pressed = inputs[input_key]
		if input_pressed:
			user_direction = input_key
			return user_direction
	return user_direction
