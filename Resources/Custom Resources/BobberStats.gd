extends Resource

class_name BobberStats
export(float) var initial_bobber_attack_amount
export(float) var initial_bobber_attack_rate 
export(float) var initial_damage_multiplier
export(int) var hooks_amount # aka number of lives
export(int) var gold_amount

var raw_bobber_attack_amount : float # does not have damage multiplier yet
var bobber_attack_amount : float # amount filled in fish progress bar per attack rate, has damage multiplier
var bobber_attack_rate : float 
var damage_multiplier : float # anything that fills fish progress bar counts as damage

var die_young : bool = false # take double damage if true
var turned_underdog : bool = false # will be true if gained underdog buff

var poke_damage : float
var pull_out_damage : float

var intimidate_damage : float
var retaliate_damage : float

var reassuring_confidence_stacks : int = 0
var masochistic_stacks : int = 0
var thrill_seeker_stacks : int = 0
var pumping_iron_stacks : int = 0

# called in ready function of bobber
# helps to reset stats upon fishing after leaving shop
func set_up_initial_stats() -> void:
	raw_bobber_attack_amount = initial_bobber_attack_amount
	bobber_attack_rate = initial_bobber_attack_rate
	damage_multiplier = initial_damage_multiplier
	turned_underdog = false # resets underdog
	reassuring_confidence_stacks = 0 # resets reassuring confidence stacks
	masochistic_stacks = 0 # resets masochistic stacks
	thrill_seeker_stacks = 0 # resets thrill seeker stacks
	pumping_iron_stacks = 0 # resets pumping iron stacks


func minus_hook(damage : int) -> void:
	hooks_amount -= damage
	if die_young:
		hooks_amount -= damage
	if hooks_amount < 0:
		hooks_amount = 0


func gain_hook(num_of_hook_gained : int) -> void:
	hooks_amount += num_of_hook_gained


func increment_gold(gold_gained : int) -> void:
	gold_amount += gold_gained
	

func decrement_gold(gold_lost : int) -> void:
	gold_amount -= gold_lost
	

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


func compute_retaliate_damage(raw_retaliate_damage : float) -> void:
	retaliate_damage = raw_retaliate_damage
	retaliate_damage *= damage_multiplier
