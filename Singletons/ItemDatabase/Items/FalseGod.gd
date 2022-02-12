extends ItemSpecification

export(Resource) var bobber_stats = bobber_stats as BobberStats
export(Array, float) var increment_reel_damage

func trigger_at_level_1(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_stats_at_start_of_fishing:
		bobber_stats.change_reel_damage(increment_reel_damage[0])
	elif trigger_cause == TRIGGER_CAUSES.override_stats_at_start_of_fishing:
		bobber_stats.set_max_hook(1)
	elif trigger_cause == TRIGGER_CAUSES.sold_this_item:
		bobber_stats.set_max_hook(bobber_stats.initial_max_hooks_amount)
		bobber_stats.reconfigure_hook()


func trigger_at_level_2(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_stats_at_start_of_fishing:
		bobber_stats.change_reel_damage(increment_reel_damage[1])
	elif trigger_cause == TRIGGER_CAUSES.override_stats_at_start_of_fishing:
		bobber_stats.set_max_hook(1)
	elif trigger_cause == TRIGGER_CAUSES.sold_this_item:
		bobber_stats.set_max_hook(bobber_stats.initial_max_hooks_amount)
		bobber_stats.reconfigure_hook()


func trigger_at_level_3(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_stats_at_start_of_fishing:
		bobber_stats.change_reel_damage(increment_reel_damage[2])
	elif trigger_cause == TRIGGER_CAUSES.override_stats_at_start_of_fishing:
		bobber_stats.set_max_hook(1)
	elif trigger_cause == TRIGGER_CAUSES.sold_this_item:
		bobber_stats.set_max_hook(bobber_stats.initial_max_hooks_amount)
		bobber_stats.reconfigure_hook()
