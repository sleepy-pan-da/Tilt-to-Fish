extends TextureRect


onready var label = $Label

func update_label(bobber_stats : BobberStats) -> void:
	label.text = str(bobber_stats.hooks_amount) + "/" + str(bobber_stats.max_hooks_amount)
