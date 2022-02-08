extends Control

export(Resource) var bobber_stats = bobber_stats as BobberStats
export(Resource) var backpack = backpack as BackPack
export(String, FILE, "*.tscn") var game_scene 

onready var hooks = $UpperLeftCorner/Hooks
onready var gold = $UpperLeftCorner/Gold
onready var round_number = $RoundNumber
onready var description_box = $ShopPanel/DescriptionBox
onready var backpack_slots = $ShopPanel/ItemSlots
onready var items_sold = $ShopPanel/ItemsSold
#onready var lock_button = $Lock
#onready var reroll_button = $Reroll
onready var screen_transition = $ScreenTransition

var index_of_currently_pressed_item : int = -1

func _ready() -> void:
	screen_transition.transition_in()
	backpack.level_up_all_held_items()
	hooks.update_label(bobber_stats.hooks_amount, bobber_stats.max_hooks_amount)
	gold.update_label(bobber_stats.gold_amount)
	round_number.update_round_number(GameData.round_number)
	items_sold.set_up_items_sold(backpack)
	
	backpack_slots.update_backpack_ui(backpack)
	
#	reroll_button.connect("clicked_reroll", self, "on_clicked_reroll")
	items_sold.get_child(0).connect("pressed", self, "on_pressed_items_sold", [0])
	items_sold.get_child(1).connect("pressed", self, "on_pressed_items_sold", [1])
	items_sold.get_child(2).connect("pressed", self, "on_pressed_items_sold", [2])
	description_box.buy_sell_button.connect("clicked_buy_sell_button", self, "on_clicked_buy_sell_button")
	backpack_slots.get_child(0).connect("pressed", self, "on_pressed_backpack_slot", [0])
	backpack_slots.get_child(1).connect("pressed", self, "on_pressed_backpack_slot", [1])
	backpack_slots.get_child(2).connect("pressed", self, "on_pressed_backpack_slot", [2])
	backpack_slots.get_child(3).connect("pressed", self, "on_pressed_backpack_slot", [3])
	backpack_slots.get_child(4).connect("pressed", self, "on_pressed_backpack_slot", [4])
	screen_transition.connect("transitioned_out", self, "go_back_to_fishing")
	

#func on_clicked_reroll() -> void:
#	if bobber_stats.gold_amount >= 2:
#		bobber_stats.decrement_gold(2)
#		gold.update_gold_label(bobber_stats.gold_amount)
#		items_sold.pick_items_sold()
#		description_box.hide()
#		index_of_currently_pressed_item = -1


func on_pressed_items_sold(child_index : int) -> void:
	index_of_currently_pressed_item = child_index
	var item_name : String = items_sold.get_child(child_index).text
	if item_name != "": # bought the item alr, no more item offered for sale
		if !description_box.visible:
			description_box.show() 
		description_box.update_description_box_from_items_sold(item_name, child_index)
	else:
		description_box.hide()
		return


func on_pressed_backpack_slot(index_of_backpack_keys : int) -> void:
	var array_of_backpack_keys : Array = backpack.get_items_of_backpack()
	var item_name : String 

	if index_of_backpack_keys <= array_of_backpack_keys.size() - 1:
		item_name = array_of_backpack_keys[index_of_backpack_keys]
	else:
		description_box.hide()
		return

	if item_name != "":
		if !description_box.visible:
			description_box.show() 
		# need to add 3 to compensate for the first 3 edges pointing to items sold
		description_box.update_description_box_from_backpack_slots(backpack, item_name, index_of_backpack_keys + 3) 


func on_clicked_buy_sell_button() -> void:
	var name_of_item : String = description_box.item_name.get_item_name()
	var cost_of_item : int = description_box.item_cost.get_item_cost()
	if name_of_item == "": 
		return
	
	var button_icon : Texture = description_box.buy_sell_button.texture_normal
	if button_icon == description_box.buy_sell_button.BuyButtonTexture:
		var can_afford : bool = bobber_stats.gold_amount >= cost_of_item
		
		if can_afford: 
			if !backpack.has_item(name_of_item) and backpack.has_space():
				#add item to backpack
				bobber_stats.change_gold(-cost_of_item)
				gold.update_label(bobber_stats.gold_amount)
				backpack.add_item(name_of_item)
				items_sold.get_child(index_of_currently_pressed_item).text = ""
				description_box.hide()
				backpack_slots.update_backpack_ui(backpack)

	elif button_icon == description_box.buy_sell_button.SellButtonTexture:
		backpack.remove_item_from_backpack(name_of_item)
		description_box.hide()
		backpack_slots.update_backpack_ui(backpack)
		# earn money from selling item
		bobber_stats.change_gold(cost_of_item)
		gold.update_label(bobber_stats.gold_amount)


func _on_NextWave_pressed() -> void:
	screen_transition.transition_out()


func go_back_to_fishing() -> void:
#	if lock_button.pressed:
#		items_sold.lock_items()
#	else:
#		items_sold.forget_locked_items()
	get_tree().change_scene(game_scene)
