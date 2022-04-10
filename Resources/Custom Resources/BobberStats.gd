extends Resource

class_name BobberStats
export(float) var initial_reel_damage # damage that you deal when you are near fish
export(float) var initial_reel_attack_rate 
export(int) var initial_max_hooks_amount # aka number of lives
export(int) var initial_max_orbs
export(int) var initial_gold_amount

var gold_amount : int
var max_hooks_amount : int
var hooks_amount : int
var reel_damage : float 
var previous_reel_damage : float = 0.0 # Need this for time lord victorious
var reel_attack_rate : float 
var max_orbs : int
var orb_cooldown_reduction : float = 1.0
var slows_down_time_by : float = 1.0
var damage_taken_multiplier : float = 1.0
var biscuit_tin_stack_count : int = 0

var first_time_setting_up : bool = true
var took_damage_in_round : bool = false

# called in ready function of bobber
# helps to reset stats upon fishing after leaving shop
func set_up_initial_stats() -> void:
	max_hooks_amount = initial_max_hooks_amount
	if first_time_setting_up:
		hooks_amount = max_hooks_amount
		gold_amount = initial_gold_amount
		first_time_setting_up = false
		biscuit_tin_stack_count = 0
	
	reel_damage = initial_reel_damage
	previous_reel_damage = 0
	reel_attack_rate = initial_reel_attack_rate
	max_orbs = initial_max_orbs
	orb_cooldown_reduction = 1.0
	slows_down_time_by = 1.0
	damage_taken_multiplier = 1.0
	took_damage_in_round = false


func reset_hooks_and_max_hooks() -> void:
	max_hooks_amount = initial_max_hooks_amount
	hooks_amount = max_hooks_amount
	

func minus_hook(damage : int) -> void:
	hooks_amount -= damage
	took_damage_in_round = true
	if hooks_amount < 0:
		hooks_amount = 0


func gain_hook(num_of_hook_gained : int) -> void:
	hooks_amount += num_of_hook_gained
	if hooks_amount > max_hooks_amount:
		reconfigure_hook()
	GameEvents.emit_signal("bobber_gained_hook", num_of_hook_gained)


# In the scenario where hook > max hook, hook needs to be reconfigured 
func reconfigure_hook() -> void:
	hooks_amount = max_hooks_amount
	

func change_max_hook(change_in_max_hook : int) -> void:
	max_hooks_amount += change_in_max_hook


func set_max_hook(number_to_set : int) -> void:
	max_hooks_amount = number_to_set


func change_max_orbs(change_in_max_orbs : int) -> void:
	max_orbs += change_in_max_orbs


func change_orb_cooldown_reduction(change_in_cooldown_reduction : float) -> void:
	orb_cooldown_reduction += change_in_cooldown_reduction


func multiply_damage_taken_multiplier(multiplier : float) -> void: # for the scenario where you have 2 double damage taken items
	damage_taken_multiplier *= multiplier


func change_biscuit_tin_stack_count(change_in_stack_count : int) -> void:
	biscuit_tin_stack_count += change_in_stack_count


func set_max_orbs(number_to_set : int) -> void:
	max_orbs = number_to_set
	

func change_gold(change_in_gold : int) -> void:
	gold_amount += change_in_gold


func compute_interest() -> int:
	var interest : int = gold_amount / 3
	return interest


func reset_when_game_over() -> void: 
	gold_amount = initial_gold_amount
	first_time_setting_up = true
	
	
func change_reel_damage(change_in_reel_damage : float) -> void:
	reel_damage += change_in_reel_damage	
