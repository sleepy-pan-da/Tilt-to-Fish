extends Node
class_name ItemSpecification

func trigger(item_level : int) -> void:
	match item_level:
		1:
			trigger_at_level_1()
		2:
			trigger_at_level_2()
		3:
			trigger_at_level_3()
		_:
			print("item level not registered")



func trigger_at_level_1() -> void:
	pass
	

func trigger_at_level_2() -> void:
	pass


func trigger_at_level_3() -> void:
	pass 
	
