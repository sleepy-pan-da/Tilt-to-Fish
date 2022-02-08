extends TextureRect


onready var label = $Label

func update_label(gold_amount : int) -> void:
	if gold_amount >= 10:
		label.text = str(gold_amount)
	else:
		label.text = "0" + str(gold_amount)
