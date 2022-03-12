extends ItemSpecification

export(Resource) var bobber_stats = bobber_stats as BobberStats
export(Array, float) var increment_gold_earned_at_diff_levels


func trigger_at_level_1(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.visited_shop:
		if bobber_stats.took_damage_in_round:
			bobber_stats.change_biscuit_tin_stack_count(-bobber_stats.biscuit_tin_stack_count)
		else:
			bobber_stats.change_biscuit_tin_stack_count(1)
		bobber_stats.change_gold(bobber_stats.biscuit_tin_stack_count * increment_gold_earned_at_diff_levels[0])
	elif trigger_cause == TRIGGER_CAUSES.sold_this_item:
		bobber_stats.change_biscuit_tin_stack_count(-bobber_stats.biscuit_tin_stack_count)


func trigger_at_level_2(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.visited_shop:
		if bobber_stats.took_damage_in_round:
			bobber_stats.change_biscuit_tin_stack_count(-bobber_stats.biscuit_tin_stack_count)
		else:
			bobber_stats.change_biscuit_tin_stack_count(1)
		bobber_stats.change_gold(bobber_stats.biscuit_tin_stack_count * increment_gold_earned_at_diff_levels[1])
	elif trigger_cause == TRIGGER_CAUSES.sold_this_item:
		bobber_stats.change_biscuit_tin_stack_count(-bobber_stats.biscuit_tin_stack_count)


func trigger_at_level_3(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.visited_shop:
		if bobber_stats.took_damage_in_round:
			bobber_stats.change_biscuit_tin_stack_count(-bobber_stats.biscuit_tin_stack_count)
		else:
			bobber_stats.change_biscuit_tin_stack_count(1)
		bobber_stats.change_gold(bobber_stats.biscuit_tin_stack_count * increment_gold_earned_at_diff_levels[2])
	elif trigger_cause == TRIGGER_CAUSES.sold_this_item:
		bobber_stats.change_biscuit_tin_stack_count(-bobber_stats.biscuit_tin_stack_count)
