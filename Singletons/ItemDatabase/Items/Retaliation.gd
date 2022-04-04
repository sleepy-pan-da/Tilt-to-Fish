extends ItemSpecification

export(Array, float) var increment_values_at_diff_levels


func trigger_at_level_1(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.lost_hook:
		GameEvents.emit_signal("triggered_item_that_requires_bobber", name, increment_values_at_diff_levels[0])
	

func trigger_at_level_2(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.lost_hook:
		GameEvents.emit_signal("triggered_item_that_requires_bobber", name, increment_values_at_diff_levels[1])


func trigger_at_level_3(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.lost_hook:
		GameEvents.emit_signal("triggered_item_that_requires_bobber", name, increment_values_at_diff_levels[2])
