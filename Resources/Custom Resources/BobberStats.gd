extends Resource

class_name BobberStats
export(float) var initial_bobber_attack_amount
export(float) var initial_bobber_attack_rate 
export(int) var hooks_amount # aka number of lives
var bobber_attack_amount : float # amount filled in fish progress bar per attack rate
var bobber_attack_rate : float 

func set_up_initial_stats() -> void:
	
	bobber_attack_amount = initial_bobber_attack_amount
	bobber_attack_rate = initial_bobber_attack_rate
	

func minus_hook(damage : int) -> void:
	hooks_amount -= damage


func reset() -> void: # called when u restart
	hooks_amount = 3
