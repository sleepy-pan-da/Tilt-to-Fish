extends ItemSpecification

export(Resource) var bobber_stats = bobber_stats as BobberStats
export(Array, float) var increment_gold_earned_at_diff_levels

func trigger_at_level_1(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.bought_other_item or TRIGGER_CAUSES.sold_other_item:
		bobber_stats.change_gold(increment_gold_earned_at_diff_levels[0])


func trigger_at_level_2(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.bought_other_item or TRIGGER_CAUSES.sold_other_item:
		bobber_stats.change_gold(increment_gold_earned_at_diff_levels[1])


func trigger_at_level_3(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.bought_other_item or TRIGGER_CAUSES.sold_other_item:
		bobber_stats.change_gold(increment_gold_earned_at_diff_levels[2])
