extends Control

export(Resource) var item_pool = item_pool as ItemPool

onready var item_name = $ItemName
onready var item_cost = $ItemCost
onready var item_description = $ItemDescription
onready var buy_sell_button = $BuySellButton

func update_description_box_from_items_sold(item : String) -> void:
	item_name.update_item_name(item)
	if item_pool.item_info.has(item):
		item_cost.update_item_cost(item_pool.item_info[item]["Cost"])
		item_description.update_item_description(item_pool.item_info[item]["Description"])
	buy_sell_button.update_to_buy()


func update_description_box_from_backpack_slots(item : String) -> void:
	item_name.update_item_name(item)
	if item_pool.item_info.has(item):
		item_cost.update_item_cost(item_pool.item_info[item]["Cost"])
		item_description.update_item_description(item_pool.item_info[item]["Description"])
	buy_sell_button.update_to_sell()



