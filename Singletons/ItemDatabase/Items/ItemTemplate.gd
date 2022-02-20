extends Node
class_name ItemSpecification

enum TRIGGER_CAUSES {
	set_up_stats_at_start_of_fishing, 
	set_up_bobber_item_at_start_of_fishing,
	override_stats_at_start_of_fishing,
	lost_all_hooks,
	caught_fish,
	set_up_orb_spawners_at_start_of_fishing,
	bought_this_item, # this is needed to update shop ui
	sold_this_item # this is needed to update shop ui
	}

func trigger(item_level : int, trigger_cause : int) -> void:
	match item_level:
		1:
			trigger_at_level_1(trigger_cause)
		2:
			trigger_at_level_2(trigger_cause)
		3:
			trigger_at_level_3(trigger_cause)
		_:
			print("item level not registered")



func trigger_at_level_1(trigger_cause : int) -> void:
	pass
	

func trigger_at_level_2(trigger_cause : int) -> void:
	pass


func trigger_at_level_3(triggered_by : int) -> void:
	pass 
	
