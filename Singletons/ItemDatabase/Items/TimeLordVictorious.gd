extends ItemSpecification

export(Resource) var bobber_stats = bobber_stats as BobberStats
export(Array, float) var increment_stop_time_duration_at_diff_levels
export(Array, float) var increment_cooldown_at_diff_levels

func trigger_at_level_1(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_orb_spawners_at_start_of_fishing:
		var incremented_values = [increment_stop_time_duration_at_diff_levels[0], increment_cooldown_at_diff_levels[0]]
		GameEvents.emit_signal("set_up_orb_spawner_at_start_of_fishing", name, incremented_values)


func trigger_at_level_2(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_orb_spawners_at_start_of_fishing:
		var incremented_values = [increment_stop_time_duration_at_diff_levels[0], increment_cooldown_at_diff_levels[0]]
		GameEvents.emit_signal("set_up_orb_spawner_at_start_of_fishing", name, incremented_values)


func trigger_at_level_3(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_orb_spawners_at_start_of_fishing:
		var incremented_values = [increment_stop_time_duration_at_diff_levels[0], increment_cooldown_at_diff_levels[0]]
		GameEvents.emit_signal("set_up_orb_spawner_at_start_of_fishing", name, incremented_values)
