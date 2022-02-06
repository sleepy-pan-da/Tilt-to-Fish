extends HBoxContainer

export(Resource) var item_pool = item_pool as ItemPool

var items_sold : Array = []

func _ready() -> void:
#	if item_pool.have_locked_items():
#		remember_locked_items()
#	else:
#		pick_items_sold()
	pass


func pick_items_sold() -> void:
	items_sold.clear()
	for i in range(3):
		items_sold.append(item_pool.pick_an_item())
		get_child(i).text = items_sold[i]


func lock_items() -> void:
	items_sold.clear()
	for i in range(3):
		items_sold.append(get_child(i).text)
	item_pool.locked_items = items_sold


func remember_locked_items() -> void:
	items_sold.clear()
	items_sold = item_pool.locked_items
	for i in range(items_sold.size()):
		get_child(i).text = items_sold[i]
	

func forget_locked_items() -> void:
	item_pool.locked_items.clear()
