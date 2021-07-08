extends Resource

class_name BobberStats
export(float) var bobber_attack_amount # amount filled in fish progress bar per attack rate
export(float) var bobber_attack_rate 
export(int) var hooks_amount # aka number of lives
export(float) var bobber_flow_max_amount # amount required to fill flow completely
export(float) var bobber_flow_increment_amount # amount filled in flow bar per 0.1s
export(float) var bobber_flow_decrement_amount # amount emptied in flow bar per 0.1s

func minus_hook(damage : int) -> void:
	hooks_amount -= damage


func reset() -> void: # called when u restart
	hooks_amount = 3
