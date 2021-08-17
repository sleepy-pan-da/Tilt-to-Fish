extends Control

onready var gold_label = $GoldLabel

func update_gold_label(gold_amount : int) -> void:
	if gold_amount >= 10:
		gold_label.text = str(gold_amount)
	else:
		gold_label.text = "0" + str(gold_amount)
