extends HBoxContainer

export(Resource) var item_pool = item_pool as ItemPool

var items_sold : Array = []

func _ready() -> void:
#	if item_pool.have_locked_items():
#		remember_locked_items()
#	else:
#		pick_items_sold()
	#pick_items_sold()
	pass


func set_up_items_sold(backpack : BackPack) -> void:
	pick_items_sold(backpack)


# There will be no duplicated items
# e.g. No duplicated items in items sold
# e.g. Items currently held in backpack will not appear
func pick_items_sold(backpack : BackPack) -> void:
	items_sold.clear()
	while items_sold.size() != 3:
		var chosen_item : ItemTraits = item_pool.pick_an_item_randomly()
		if !items_sold.has(chosen_item) and !backpack.has_item(chosen_item.resource_name):
			items_sold.append(chosen_item)
			var index_of_added_item : int = items_sold.size() - 1
			get_child(index_of_added_item).text = items_sold[index_of_added_item].resource_name



#func lock_items() -> void:
#	items_sold.clear()
#	for i in range(3):
#		items_sold.append(get_child(i).text)
#	item_pool.locked_items = items_sold
#
#
#func remember_locked_items() -> void:
#	items_sold.clear()
#	items_sold = item_pool.locked_items
#	for i in range(items_sold.size()):
#		get_child(i).text = items_sold[i]
#
#
#func forget_locked_items() -> void:
#	item_pool.locked_items.clear()
