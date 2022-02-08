extends TextureRect


onready var label = $Label

func update_label(current_hooks_amount : int, max_hooks_amount : int) -> void:
	label.text = str(current_hooks_amount) + "/" + str(max_hooks_amount)
