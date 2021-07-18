extends Resource

class_name BobberStats
export(float) var initial_bobber_attack_amount
export(float) var initial_bobber_attack_rate 
export(float) var initial_damage_multiplier
export(int) var hooks_amount # aka number of lives
var raw_bobber_attack_amount : float # does not have damage multiplier yet
var bobber_attack_amount : float # amount filled in fish progress bar per attack rate, has damage multiplier
var bobber_attack_rate : float 
var damage_multiplier : float # anything that fills fish progress bar counts as damage

var die_young : bool = false # take double damage if true
var turned_underdog : bool = false # will be true if gained underdog buff

var can_poke : bool = false 
var poke_damage : float
var can_pull_out : bool = false
var pull_out_damage : float

var intimidate_damage : float

# called in ready function of bobber
# helps to reset stats
func set_up_initial_stats() -> void:
	raw_bobber_attack_amount = initial_bobber_attack_amount
	bobber_attack_rate = initial_bobber_attack_rate
	damage_multiplier = initial_damage_multiplier
	turned_underdog = false # resets underdog


func minus_hook(damage : int) -> void:
	hooks_amount -= damage
	if die_young:
		hooks_amount -= damage
	if hooks_amount < 0:
		hooks_amount = 0


func gain_hook(num_of_hook_gained : int) -> void:
	hooks_amount += num_of_hook_gained
	

func reset_when_game_over() -> void: 
	hooks_amount = 3
	turned_underdog = false


func compute_bobber_attack_amount() -> void: # considers damage multiplier
	bobber_attack_amount = raw_bobber_attack_amount
	bobber_attack_amount *= damage_multiplier


func compute_poke_damage(raw_poke_damage : float) -> void:
	poke_damage = raw_poke_damage
	poke_damage *= damage_multiplier


func compute_pull_out_damage(raw_pull_out_damage : float) -> void:
	pull_out_damage = raw_pull_out_damage
	pull_out_damage *= damage_multiplier 


func compute_intimidate_damage(raw_intimidate_damage : float) -> void:
	intimidate_damage = raw_intimidate_damage
	intimidate_damage *= damage_multiplier
