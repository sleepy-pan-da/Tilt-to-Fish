extends Control

export(Resource) var bobber_stats = bobber_stats as BobberStats
export(Resource) var backpack = backpack as BackPack
export(String, FILE, "*.tscn") var game_scene 

onready var screen_transition = $ScreenTransition
onready var hooks = $Hooks
onready var gold = $Gold
onready var round_number = $RoundNumber
onready var items_sold = $ItemsSold
onready var description_box = $DescriptionBox
onready var backpack_slots = $Backpack/ItemSlots

var index_of_currently_pressed_item : int = -1

func _ready() -> void:
	screen_transition.transition_in()
	hooks.update_hooks_label(bobber_stats.hooks_amount)
	gold.update_gold_label(bobber_stats.gold_amount)
	round_number.update_round_number(GameData.round_number)
	backpack_slots.update_backpack_ui(backpack)
	items_sold.get_child(0).connect("pressed", self, "on_pressed_items_sold", [0])
	items_sold.get_child(1).connect("pressed", self, "on_pressed_items_sold", [1])
	items_sold.get_child(2).connect("pressed", self, "on_pressed_items_sold", [2])
	description_box.buy_sell_button.connect("pressed", self, "on_pressed_buy_sell_button")
	backpack_slots.get_child(0).connect("pressed", self, "on_pressed_backpack_slot", [0])
	backpack_slots.get_child(1).connect("pressed", self, "on_pressed_backpack_slot", [1])
	backpack_slots.get_child(2).connect("pressed", self, "on_pressed_backpack_slot", [2])
	backpack_slots.get_child(3).connect("pressed", self, "on_pressed_backpack_slot", [3])
	backpack_slots.get_child(4).connect("pressed", self, "on_pressed_backpack_slot", [4])
	screen_transition.connect("transitioned_out", self, "go_back_to_fishing")
	

func _on_Reroll_pressed() -> void:
	if bobber_stats.gold_amount >= 2:
		bobber_stats.decrement_gold(2)
		gold.update_gold_label(bobber_stats.gold_amount)
		items_sold.pick_items_sold()
		description_box.hide()
		index_of_currently_pressed_item = -1


func on_pressed_items_sold(child_index : int) -> void:
	index_of_currently_pressed_item = child_index
	var item_name : String = items_sold.get_child(child_index).text
	if item_name != "": # bought the item alr, no more item offered for sale
		if !description_box.visible:
			description_box.show() 
		description_box.update_description_box_from_items_sold(item_name)
	else:
		description_box.hide()
		return


func on_pressed_backpack_slot(index_of_backpack_keys : int) -> void:
	var array_of_backpack_keys : Array = backpack.get_keys_of_backpack()
	var item_name : String 
	
	if index_of_backpack_keys <= array_of_backpack_keys.size() - 1:
		item_name = array_of_backpack_keys[index_of_backpack_keys]
	else:
		description_box.hide()
		return
		
	if item_name != "":
		if !description_box.visible:
			description_box.show() 
		description_box.update_description_box_from_backpack_slots(item_name)
	

func on_pressed_buy_sell_button() -> void:
	print("hi")
	var button_text : String = description_box.buy_sell_button.text
	if button_text == "Buy":
		var name_of_item_to_buy : String = description_box.item_name.get_item_name()
		var cost_of_item_to_buy : int = description_box.item_cost.get_item_cost()
		
		if name_of_item_to_buy == "": # bought the item alr, no more item offered for sale
			return
		var can_afford : bool = bobber_stats.gold_amount >= cost_of_item_to_buy
		
		if can_afford:
			if backpack.has_space():
				#add item to backpack
				bobber_stats.decrement_gold(cost_of_item_to_buy)
				gold.update_gold_label(bobber_stats.gold_amount)
				backpack.add_item(name_of_item_to_buy)
				items_sold.get_child(index_of_currently_pressed_item).text = ""
				description_box.hide()
				backpack_slots.update_backpack_ui(backpack)
			elif backpack.has_item(name_of_item_to_buy) and !backpack.item_is_maxed_out(name_of_item_to_buy):
				#add item to backpack
				bobber_stats.decrement_gold(cost_of_item_to_buy)
				gold.update_gold_label(bobber_stats.gold_amount)
				backpack.add_item(name_of_item_to_buy)
				items_sold.get_child(index_of_currently_pressed_item).text = ""
				description_box.hide()
				backpack_slots.update_backpack_ui(backpack)
			else:
				return
		
		
	elif button_text == "Sell":
		var name_of_item_to_sell : String = description_box.item_name.get_item_name()
		var cost_of_item_to_sell : int = description_box.item_cost.get_item_cost()
		
		if name_of_item_to_sell != "":
			backpack.remove_item_from_backpack(name_of_item_to_sell)
			if !backpack.has_item(name_of_item_to_sell):
				description_box.hide()
			backpack_slots.update_backpack_ui(backpack)
			# earn money from selling item
			bobber_stats.increment_gold(cost_of_item_to_sell)
			gold.update_gold_label(bobber_stats.gold_amount)


func _on_NextWave_pressed() -> void:
	screen_transition.transition_out()


func go_back_to_fishing() -> void:
	get_tree().change_scene(game_scene)
