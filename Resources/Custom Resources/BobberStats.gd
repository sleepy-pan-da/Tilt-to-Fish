extends Resource

class_name BobberStats
export(float) var initial_reel_damage # damage that you deal when you are near fish
export(float) var initial_reel_attack_rate 
export(float) var initial_damage_multiplier
export(int) var hooks_amount # aka number of lives
export(int) var gold_amount

var max_hooks_amount : int = 5 # to prevent the scenario where u have a fk ton of hooks
var raw_reel_damage : float # does not have damage multiplier yet
var multiplied_reel_damage : float # amount filled in fish progress bar per attack rate, has damage multiplier
var reel_attack_rate : float 
var damage_multiplier : float # anything that fills fish progress bar counts as damage


# called in ready function of bobber
# helps to reset stats upon fishing after leaving shop
func set_up_initial_stats() -> void:
	raw_reel_damage = initial_reel_damage
	reel_attack_rate = initial_reel_attack_rate
	damage_multiplier = initial_damage_multiplier


func minus_hook(damage : int) -> void:
	hooks_amount -= damage
	if hooks_amount < 0:
		hooks_amount = 0


func gain_hook(num_of_hook_gained : int) -> void:
	hooks_amount += num_of_hook_gained
	if hooks_amount > max_hooks_amount:
		hooks_amount = max_hooks_amount
	else:
		GameEvents.emit_signal("bobber_gained_hook", num_of_hook_gained)
		
		
func increment_gold(gold_gained : int) -> void:
	gold_amount += gold_gained
	

func decrement_gold(gold_lost : int) -> void:
	gold_amount -= gold_lost
	

func reset_when_game_over() -> void: 
	gold_amount = 0
	hooks_amount = max_hooks_amount
