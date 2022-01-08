extends "res://Singletons/ItemDatabase/Items/ItemTemplate.gd"

export(Resource) var bobber_stats = bobber_stats as BobberStats
export(Array, float) var increment_values_at_diff_levels

func trigger_at_level_1() -> void:
	bobber_stats.change_reel_damage(increment_values_at_diff_levels[0])
	

func trigger_at_level_2() -> void:
	bobber_stats.change_reel_damage(increment_values_at_diff_levels[1])


func trigger_at_level_3() -> void:
	bobber_stats.change_reel_damage(increment_values_at_diff_levels[2])
