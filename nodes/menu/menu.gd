extends Node2D


func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_play_pressed() -> void:
	Globals.load_scene("game")


func _on_continue_pressed() -> void:
	$CanvasLayer/Ui/Popup.visible = false


func _on_instructions_pressed() -> void:
	$CanvasLayer/Ui/Popup.visible = true
