extends ItemSpecification

export(Resource) var bobber_stats = bobber_stats as BobberStats
export(Array, float) var increment_damage_taken_multiplier

func trigger_at_level_1(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_stats_at_start_of_fishing:
		bobber_stats.multiply_damage_taken_multiplier(increment_damage_taken_multiplier[0])
	elif trigger_cause == TRIGGER_CAUSES.visited_shop:
		var hooks_to_gain : int = bobber_stats.max_hooks_amount - bobber_stats.hooks_amount
		bobber_stats.gain_hook(hooks_to_gain)


func trigger_at_level_2(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_stats_at_start_of_fishing:
		bobber_stats.multiply_damage_taken_multiplier(increment_damage_taken_multiplier[1])
	elif trigger_cause == TRIGGER_CAUSES.visited_shop:
		var hooks_to_gain : int = bobber_stats.max_hooks_amount - bobber_stats.hooks_amount
		bobber_stats.gain_hook(hooks_to_gain)


func trigger_at_level_3(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_stats_at_start_of_fishing:
		bobber_stats.multiply_damage_taken_multiplier(increment_damage_taken_multiplier[2])
	elif trigger_cause == TRIGGER_CAUSES.visited_shop:
		var hooks_to_gain : int = bobber_stats.max_hooks_amount - bobber_stats.hooks_amount
		bobber_stats.gain_hook(hooks_to_gain)
