extends Control


onready var hooks_label = $HooksLabel

func update_hooks_label(hooks_amount : int) -> void:
	hooks_label.text = "0" + str(hooks_amount)
