extends ItemSpecification

export(Resource) var bobber_stats = bobber_stats as BobberStats
export(Array, float) var increment_values_at_diff_levels

func trigger_at_level_1(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.lost_all_hooks:
		bobber_stats.gain_hook(round(bobber_stats.max_hooks_amount * increment_values_at_diff_levels[0]))
		SfxManager.bobber.not_today.play("Not today")

func trigger_at_level_2(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.lost_all_hooks:
		bobber_stats.gain_hook(round(bobber_stats.max_hooks_amount * increment_values_at_diff_levels[1]))
		SfxManager.bobber.not_today.play("Not today")


func trigger_at_level_3(trigger_cause : int) -> void:
	if trigger_cause == TRIGGER_CAUSES.lost_all_hooks:
		bobber_stats.gain_hook(round(bobber_stats.max_hooks_amount * increment_values_at_diff_levels[2]))
		SfxManager.bobber.not_today.play("Not today")
