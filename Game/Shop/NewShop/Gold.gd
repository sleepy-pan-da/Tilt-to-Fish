extends TextureRect


onready var label = $Label

func update_label(bobber_stats : BobberStats) -> void:
	var gold_amount : int = bobber_stats.gold_amount
	if gold_amount >= 10:
		label.text = str(gold_amount)
	else:
		label.text = "0" + str(gold_amount)
