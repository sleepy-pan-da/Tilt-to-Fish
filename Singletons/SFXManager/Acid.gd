extends "res://Singletons/SFXManager/UI.gd"

var acid_triggers_on_stack : int = 0 setget set_acid_triggers_on_stack

func set_acid_triggers_on_stack(new_value : int) -> void:
	acid_triggers_on_stack = new_value
	if acid_triggers_on_stack < 0: 
		acid_triggers_on_stack = 0
