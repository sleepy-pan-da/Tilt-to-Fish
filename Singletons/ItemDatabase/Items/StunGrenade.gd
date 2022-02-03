extends ItemSpecification

export(Array, float) var increment_stun_duration
export(Array, float) var increment_cooldown_at_diff_levels


func trigger_at_level_1(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_orb_spawners_at_start_of_fishing:
		var incremented_values = [increment_stun_duration[0], increment_cooldown_at_diff_levels[0]]
		GameEvents.emit_signal("set_up_orb_spawner_at_start_of_fishing", name, incremented_values)


func trigger_at_level_2(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_orb_spawners_at_start_of_fishing:
		var incremented_values = [increment_stun_duration[1], increment_cooldown_at_diff_levels[1]]
		GameEvents.emit_signal("set_up_orb_spawner_at_start_of_fishing", name, incremented_values)


func trigger_at_level_3(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_orb_spawners_at_start_of_fishing:
		var incremented_values = [increment_stun_duration[2], increment_cooldown_at_diff_levels[2]]
		GameEvents.emit_signal("set_up_orb_spawner_at_start_of_fishing", name, incremented_values)
