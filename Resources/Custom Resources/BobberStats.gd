extends Resource

class_name BobberStats
export(float) var bobber_attack_amount # amount filled in fish progress bar per 0.1s
export(int) var hooks_amount # aka number of lives


func minus_hook(damage : int) -> void:
	hooks_amount -= damage
	if hooks_amount <= 0:
		GameEvents.emit_signal("bobber_ran_out_of_hooks")
