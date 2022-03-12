extends Control

export(Resource) var item_pool = item_pool as ItemPool
export(Resource) var bobber_stats = bobber_stats as BobberStats

onready var item_name = $Header/ItemName
onready var item_type = $Header/ItemType
onready var item_description = $ItemDescription
onready var item_cost = $RightSide/ItemCost
onready var item_rarity = $RightSide/ItemRarity
onready var item_selling_costs = $RightSide/ItemSellingCosts
onready var item_exp = $RightSide/ItemExp
onready var buy_sell_button = $BuySellButton
onready var speech_bubble_edges = $SpeechBubbleEdges

func update_description_box_from_items_sold(item : String, speech_bubble_index : int) -> void:	
	var item_details : ItemTraits = item_pool.get_item(item)
	if item_details == null:
		return
	update_description_box_with_item_details(item_details)
	
	item_cost.update_item_cost(item_details.buying_cost)	
	
	item_exp.update_item_exp(0)
	speech_bubble_edges.update_bubble_edges(speech_bubble_index)
	buy_sell_button.update_to_buy()


func update_description_box_from_backpack_slots(backpack : BackPack, item : String, speech_bubble_index : int) -> void:
	var item_details : ItemTraits = item_pool.get_item(item)
	if item_details == null:
		return
	update_description_box_with_item_details(item_details)
	
	var item_level : int = backpack.get_item_level(item)
	item_cost.update_item_cost(item_details.selling_cost[item_level - 1])		
	
	item_exp.update_item_exp(backpack.held_items[item_details.resource_name])
	speech_bubble_edges.update_bubble_edges(speech_bubble_index)
	buy_sell_button.update_to_sell()


func update_description_box_with_item_details(item_details : ItemTraits) -> void:
	item_name.update_item_name(item_details.resource_name)
	item_type.update_item_type(item_details.spawns_orbs)
	item_description.update_item_description(item_details.description)
	item_selling_costs.update_item_selling_costs(item_details.selling_cost)
	
	if item_details.name == "Biscuit Tin":
		item_description.append_item_description(String(bobber_stats.biscuit_tin_stack_count))
	#item_rarity.update_item_rarity(item_details.rarity)
	
