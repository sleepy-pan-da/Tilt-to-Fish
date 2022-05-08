extends Control

export(Resource) var item_pool = item_pool as ItemPool
export(Resource) var bobber_stats = bobber_stats as BobberStats

onready var item_name = $Header/ItemName
onready var item_type = $Header/ItemType
onready var item_description = $ItemDescription
#onready var item_cost = $Body/ItemCost
onready var item_cost = $Bottom/BuySellButton/ItemCost
onready var item_rarity = $Body/ItemRarity
onready var item_selling_costs = $Body/ItemSellingCosts
onready var item_exp = $Body/ItemExp
onready var buy_sell_button = $Bottom/BuySellButton

func update_description_box_from_items_sold(item : String) -> void:	
	var item_details : ItemTraits = item_pool.get_item(item)
	if item_details == null:
		return
	update_description_box_with_item_details(item_details)
	
	item_exp.update_item_exp(0)
	item_cost.update_item_cost(item_details.buying_cost)	
	buy_sell_button.update_to_buy(item_details.buying_cost)


func update_description_box_from_backpack_slots(backpack : BackPack, item : String) -> void:
	var item_details : ItemTraits = item_pool.get_item(item)
	if item_details == null:
		return
	update_description_box_with_item_details(item_details)
	
	var item_level : int = backpack.get_item_level(item)
	item_exp.update_item_exp(backpack.held_items[item_details.display_name])
	item_cost.update_item_cost(item_details.selling_cost[item_level - 1])		
	buy_sell_button.update_to_sell(item_details.selling_cost[item_level - 1])


func update_description_box_with_item_details(item_details : ItemTraits) -> void:
	item_name.update_item_name(item_details.display_name)
	item_type.update_item_type(item_details.spawns_orbs)
	item_description.update_item_description(item_details.description)
	item_selling_costs.update_item_selling_costs(item_details.selling_cost)
	
	if item_details.display_name == "Biscuit Tin":
		item_description.append_item_description(String(bobber_stats.biscuit_tin_stack_count))
	#item_rarity.update_item_rarity(item_details.rarity)
	
