extends ItemSpecification

export(Resource) var bobber_stats = bobber_stats as BobberStats
export(Array, float) var increment_reel_damage

func trigger_at_level_1(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_stats_at_start_of_fishing:
		bobber_stats.change_reel_damage(increment_reel_damage[0])
		bobber_stats.multiply_damage_taken_multiplier(2)


func trigger_at_level_2(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_stats_at_start_of_fishing:
		bobber_stats.change_reel_damage(increment_reel_damage[1])
		bobber_stats.multiply_damage_taken_multiplier(2)


func trigger_at_level_3(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_stats_at_start_of_fishing:
		bobber_stats.change_reel_damage(increment_reel_damage[2])
		bobber_stats.multiply_damage_taken_multiplier(2)
