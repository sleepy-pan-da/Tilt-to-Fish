extends HBoxContainer

export(Resource) var occupied_item_icon

func update_backpack_ui(backpack : BackPack) -> void:
	reset_backpack_ui()
	
	var array_of_items = backpack.get_items_of_backpack()
	var number_of_items_in_backpack : int = array_of_items.size()
	for i in range(number_of_items_in_backpack):
		var current_item : String = array_of_items[i]
		var item_level : int = backpack.get_item_level(current_item)
		get_child(i).get_child(0).text = str(item_level)
		get_child(i).get_node("OccupiedItem").texture = occupied_item_icon


func reset_backpack_ui() -> void:
	for i in range(5):
		get_child(i).get_node("OccupiedItem").texture = null
		get_child(i).get_child(0).text = ""
