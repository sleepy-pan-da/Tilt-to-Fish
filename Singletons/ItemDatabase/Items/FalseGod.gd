extends ItemSpecification

export(Resource) var bobber_stats = bobber_stats as BobberStats
export(Array, float) var increment_values_at_diff_levels

func trigger_at_level_1(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_stats_at_start_of_fishing:
		bobber_stats.change_reel_damage(increment_values_at_diff_levels[0])
	elif trigger_cause == TRIGGER_CAUSES.override_stats_at_start_of_fishing:
		bobber_stats.set_max_hook(1)


func trigger_at_level_2(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_stats_at_start_of_fishing:
		bobber_stats.change_reel_damage(increment_values_at_diff_levels[1])
	elif trigger_cause == TRIGGER_CAUSES.override_stats_at_start_of_fishing:
		bobber_stats.set_max_hook(1)


func trigger_at_level_3(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_stats_at_start_of_fishing:
		bobber_stats.change_reel_damage(increment_values_at_diff_levels[2])
	elif trigger_cause == TRIGGER_CAUSES.override_stats_at_start_of_fishing:
		bobber_stats.set_max_hook(1)
