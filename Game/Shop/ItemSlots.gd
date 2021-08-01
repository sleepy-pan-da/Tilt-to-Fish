extends HBoxContainer

export(Resource) var occupied_item_icon

func update_backpack_ui(backpack : BackPack) -> void:
	reset_backpack_ui()
	
	var array_of_keys = backpack.get_keys_of_backpack()
	var number_of_items_in_backpack : int = array_of_keys.size()
	for i in range(number_of_items_in_backpack):
		var current_key : String = array_of_keys[i]
		var qty_of_item : int = backpack.backpack[current_key]
		get_child(i).set_button_icon(occupied_item_icon)
		get_child(i).get_child(0).text = str(qty_of_item)


func reset_backpack_ui() -> void:
	for i in range(5):
		get_child(i).set_button_icon(null)
		get_child(i).get_child(0).text = ""
