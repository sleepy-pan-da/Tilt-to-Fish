extends HBoxContainer

export(Resource) var item_pool = item_pool as ItemPool

var items_sold : Array = []

func _ready():
	pick_items_sold()


func pick_items_sold() -> void:
	items_sold.clear()
	for i in range(3):
		items_sold.append(item_pool.pick_an_item())
		get_child(i).text = items_sold[i]
