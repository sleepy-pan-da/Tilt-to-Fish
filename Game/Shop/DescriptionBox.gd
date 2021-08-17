extends Control

export(Resource) var item_pool = item_pool as ItemPool

onready var item_name = $ItemName
onready var item_cost = $ItemCost
onready var item_description = $ItemDescription
onready var buy_sell_button = $BuySellButton
onready var speech_bubble_edges = $SpeechBubbleEdges

func update_description_box_from_items_sold(item : String, speech_bubble_index : int) -> void:
	item_name.update_item_name(item)
	if item_pool.item_info.has(item):
		item_cost.update_item_cost(item_pool.item_info[item]["Cost"])
		item_description.update_item_description(item_pool.item_info[item]["Description"])
	buy_sell_button.update_to_buy()
	speech_bubble_edges.update_bubble_edges(speech_bubble_index)


func update_description_box_from_backpack_slots(item : String, speech_bubble_index : int) -> void:
	item_name.update_item_name(item)
	if item_pool.item_info.has(item):
		item_cost.update_item_cost(item_pool.item_info[item]["Cost"])
		item_description.update_item_description(item_pool.item_info[item]["Description"])
	buy_sell_button.update_to_sell()
	speech_bubble_edges.update_bubble_edges(speech_bubble_index)


