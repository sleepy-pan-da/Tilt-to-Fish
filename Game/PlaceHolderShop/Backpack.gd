extends HBoxContainer

onready var items = $Items
onready var quantity = $Quantity



func update_backpack_ui(backpack : BackPack) -> void:
	reset_backpack_ui()
	
	var array_of_keys = backpack.get_keys_of_backpack()
	var number_of_items_in_backpack : int = array_of_keys.size()
	for i in range(number_of_items_in_backpack):
		var current_key : String = array_of_keys[i]
		var qty_of_item : int = backpack.backpack[current_key]
		items.get_child(i).text = current_key
		quantity.get_child(i).text = str(qty_of_item)


func reset_backpack_ui() -> void:
	for i in range(5):
		items.get_child(i).text = ""
		quantity.get_child(i).text = ""
