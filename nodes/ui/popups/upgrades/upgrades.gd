extends VBoxContainer

signal window_closed

func update_content():
	$HBoxContainer/Label.text = str(Globals.money)

func _on_continue_pressed() -> void:
	window_closed.emit()

func _on_quit_pressed() -> void:
	get_tree().quit()
