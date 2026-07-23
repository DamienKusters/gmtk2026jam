extends VBoxContainer
class_name GameResults

signal window_closed

func update_content(deliveries_done: int, total_deliveries: int, delivery_reward: int, money_won: int):
	$Label2.text = "{0}/{1} deliveries\n{2} + 1 per additional delivery =".format([deliveries_done, total_deliveries, delivery_reward])
	$HBoxContainer/Label.text = str(money_won)

func _on_continue_pressed() -> void:
	window_closed.emit()
