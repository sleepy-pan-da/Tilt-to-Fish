extends Resource

class_name BobberStats
export(float) var initial_reel_damage # damage that you deal when you are near fish
export(float) var initial_reel_attack_rate 
export(int) var initial_max_hooks_amount # aka number of lives
export(int) var gold_amount

var max_hooks_amount : int
var hooks_amount : int
var reel_damage : float 
var reel_attack_rate : float 

var first_time_setting_up : bool = true

# called in ready function of bobber
# helps to reset stats upon fishing after leaving shop
func set_up_initial_stats() -> void:
	max_hooks_amount = initial_max_hooks_amount
	if first_time_setting_up:
		hooks_amount = max_hooks_amount
		first_time_setting_up = false
		
	reel_damage = initial_reel_damage
	reel_attack_rate = initial_reel_attack_rate

func minus_hook(damage : int) -> void:
	hooks_amount -= damage
	if hooks_amount < 0:
		hooks_amount = 0


func gain_hook(num_of_hook_gained : int) -> void:
	hooks_amount += num_of_hook_gained
	if hooks_amount > max_hooks_amount:
		reconfigure_hook()
	else:
		GameEvents.emit_signal("bobber_gained_hook", num_of_hook_gained)


# In the scenario where hook > max hook, hook needs to be reconfigured 
func reconfigure_hook() -> void:
	hooks_amount = max_hooks_amount
	

func change_max_hook(change_in_max_hook : int) -> void:
	max_hooks_amount += change_in_max_hook


func change_gold(change_in_gold : int) -> void:
	gold_amount += change_in_gold
	

func reset_when_game_over() -> void: 
	gold_amount = 0
	first_time_setting_up = true
	
	
func change_reel_damage(change_in_reel_damage : float) -> void:
	reel_damage += change_in_reel_damage	
