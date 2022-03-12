extends ItemSpecification

export(Resource) var bobber_stats = bobber_stats as BobberStats
export(Array, float) var increment_interest_multiplier_at_diff_levels

func trigger_at_level_1(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.visited_shop:
		var interest_accrued : int = bobber_stats.compute_interest() * increment_interest_multiplier_at_diff_levels[0]
		bobber_stats.change_gold(interest_accrued)


func trigger_at_level_2(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.visited_shop:
		var interest_accrued : int = bobber_stats.compute_interest() * increment_interest_multiplier_at_diff_levels[1]
		bobber_stats.change_gold(interest_accrued)


func trigger_at_level_3(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.visited_shop:
		var interest_accrued : int = bobber_stats.compute_interest() * increment_interest_multiplier_at_diff_levels[2]
		bobber_stats.change_gold(interest_accrued)
