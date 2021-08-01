extends Control

onready var gold_label = $GoldLabel

func update_gold_label(gold_amount : int) -> void:
	gold_label.text = str(gold_amount)
