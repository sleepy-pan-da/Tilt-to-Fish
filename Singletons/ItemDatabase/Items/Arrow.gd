extends ItemSpecification

export(Array, float) var increment_values_at_diff_levels 

func trigger_at_level_1(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_orb_spawners_at_start_of_fishing:
		GameEvents.emit_signal("set_up_orb_spawner_at_start_of_fishing", name, increment_values_at_diff_levels[0])


func trigger_at_level_2(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_orb_spawners_at_start_of_fishing:
		GameEvents.emit_signal("set_up_orb_spawner_at_start_of_fishing", name, increment_values_at_diff_levels[1])


func trigger_at_level_3(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.set_up_orb_spawners_at_start_of_fishing:
		GameEvents.emit_signal("set_up_orb_spawner_at_start_of_fishing", name, increment_values_at_diff_levels[2])
