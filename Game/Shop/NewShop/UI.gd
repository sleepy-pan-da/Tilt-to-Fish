extends Control

export(Resource) var bobber_stats = bobber_stats as BobberStats
export(Resource) var backpack = backpack as BackPack
export(Resource) var item_pool = item_pool as ItemPool
export(PackedScene) onready var current_bobber # need this to reconfigure max hooks when on buy/sold
export(String, FILE, "*.tscn") var game_scene 

onready var hooks = $UpperLeftCorner/Hooks
onready var gold = $UpperLeftCorner/Gold
onready var round_number = $RoundNumber
onready var description_box = $ShopPanel/DescriptionBox
onready var backpack_slots = $ShopPanel/ItemSlots
onready var items_sold = $ShopPanel/ItemsSold
onready var next_wave = $NextWave
#onready var lock_button = $Lock
#onready var reroll_button = $Reroll
onready var hooks_button = get_node("Hooks?")
onready var screen_transition = $ScreenTransition

var index_of_currently_pressed_item : int = -1
var bobber : Bobber

func _ready() -> void:
	SongManager.fade_out()
	screen_transition.transition_in()
	backpack.level_up_all_held_items()
	create_bobber_instance()
	hooks.update_label(bobber_stats.hooks_amount, bobber_stats.max_hooks_amount)
	gold.update_label(bobber_stats.gold_amount)
	round_number.update_round_number(GameData.round_number)
	
	item_pool.update_on_first_round()
	items_sold.set_up_items_sold(backpack)
	
	backpack_slots.update_backpack_ui(backpack)
	
#	reroll_button.connect("clicked_reroll", self, "on_clicked_reroll")
	items_sold.get_child(0).connect("pressed", self, "on_pressed_items_sold", [0])
	items_sold.get_child(1).connect("pressed", self, "on_pressed_items_sold", [1])
	items_sold.get_child(2).connect("pressed", self, "on_pressed_items_sold", [2])
	description_box.buy_sell_button.connect("clicked_buy_sell_button", self, "on_clicked_buy_sell_button")
	description_box.next_wave_button.connect("clicked_next_wave_button", self, "_on_NextWave_pressed")
	next_wave.connect("clicked_next_wave_button", self, "_on_NextWave_pressed")
	backpack_slots.get_child(0).connect("pressed", self, "on_pressed_backpack_slot", [0])
	backpack_slots.get_child(1).connect("pressed", self, "on_pressed_backpack_slot", [1])
	backpack_slots.get_child(2).connect("pressed", self, "on_pressed_backpack_slot", [2])
	backpack_slots.get_child(3).connect("pressed", self, "on_pressed_backpack_slot", [3])
	backpack_slots.get_child(4).connect("pressed", self, "on_pressed_backpack_slot", [4])
	screen_transition.connect("transitioned_out", self, "go_back_to_fishing")
	GameEvents.connect("bobber_gained_hook", self, "on_bobber_gained_hook")
	GameEvents.connect("need_to_recompute_bobber_hooks_and_max_hooks", self, "recompute_hooks_and_max_hooks")

#func on_clicked_reroll() -> void:
#	if bobber_stats.gold_amount >= 2:
#		bobber_stats.decrement_gold(2)
#		gold.update_gold_label(bobber_stats.gold_amount)
#		items_sold.pick_items_sold()
#		description_box.hide()
#		index_of_currently_pressed_item = -1


# For easier testing
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_T:
			items_sold.set_up_items_sold(backpack)


func create_bobber_instance() -> void:
	if current_bobber != null: # helps to test without bobber
		bobber = current_bobber.instance()
		bobber.on_visit_shop()


func on_pressed_items_sold(child_index : int) -> void:
	index_of_currently_pressed_item = child_index
	var item_name : String = items_sold.get_child(child_index).text
	if item_name != "": # bought the item alr, no more item offered for sale
		if !description_box.visible:
			description_box.show() 
			next_wave.hide()
		description_box.update_description_box_from_items_sold(item_name)
	else:
		description_box.hide()
		next_wave.show()
		return


func on_pressed_backpack_slot(index_of_backpack_keys : int) -> void:
	var array_of_backpack_keys : Array = backpack.get_items_of_backpack()
	var item_name : String 

	if index_of_backpack_keys <= array_of_backpack_keys.size() - 1:
		item_name = array_of_backpack_keys[index_of_backpack_keys]
	else:
		description_box.hide()
		next_wave.show()
		return

	if item_name != "":
		if !description_box.visible:
			description_box.show() 
			next_wave.hide()
		description_box.update_description_box_from_backpack_slots(backpack, item_name) 


func on_clicked_buy_sell_button() -> void:
	var item_name : String = description_box.item_name.get_item_name()
	var item_cost : int = description_box.item_cost.get_item_cost()
	if item_name == "": 
		return
	
	var button_icon : Texture = description_box.buy_sell_button.texture_normal
	if button_icon == description_box.buy_sell_button.BuyButtonTexture1Digit or button_icon == description_box.buy_sell_button.BuyButtonTexture2Digit:
		var can_afford : bool = bobber_stats.gold_amount >= item_cost
		
		if can_afford: 
			if !backpack.has_item(item_name) and backpack.has_space():
				bobber.on_buy_other_item() # this is before add item to prevent buying the item from triggering itself
				backpack.add_item(item_name)
				bobber.on_buy_item(item_name)
				
				description_box.hide()
				next_wave.show()
				backpack_slots.update_backpack_ui(backpack)
				bobber_stats.change_gold(-item_cost)
				gold.update_label(bobber_stats.gold_amount)
				hooks.update_label(bobber_stats.hooks_amount, bobber_stats.max_hooks_amount)
				items_sold.get_child(index_of_currently_pressed_item).text = ""

	elif button_icon == description_box.buy_sell_button.SellButtonTexture1Digit or button_icon == description_box.buy_sell_button.SellButtonTexture2Digit:
		var item_level : int = backpack.get_item_level(item_name)
		backpack.remove_item_from_backpack(item_name)
		bobber.on_sell_item(item_name, item_level)
		bobber.on_sell_other_item()
		
		description_box.hide()
		next_wave.show()
		backpack_slots.update_backpack_ui(backpack)
		bobber_stats.change_gold(item_cost)
		gold.update_label(bobber_stats.gold_amount)
		hooks.update_label(bobber_stats.hooks_amount, bobber_stats.max_hooks_amount)


func _on_NextWave_pressed() -> void:
	screen_transition.transition_out()
	GameData.increment_round_number()


func go_back_to_fishing() -> void:
#	if lock_button.pressed:
#		items_sold.lock_items()
#	else:
#		items_sold.forget_locked_items()
	get_tree().change_scene(game_scene)
	SongManager.fade_in()


func _on_Hooks_pressed() -> void:
	var cost_to_get_hook : int = hooks_button.get_current_cost()
	var can_afford : bool = bobber_stats.gold_amount >= cost_to_get_hook
	var can_gain_hook : bool = bobber_stats.hooks_amount < bobber_stats.max_hooks_amount
	if can_afford and can_gain_hook:
		bobber_stats.change_gold(-cost_to_get_hook)
		gold.update_label(bobber_stats.gold_amount)
		bobber_stats.gain_hook(1)
		hooks_button.update_label_on_successful_purchase()
		

func on_bobber_gained_hook(num_of_hook_gained: int) -> void:
	hooks.update_label(bobber_stats.hooks_amount, bobber_stats.max_hooks_amount)	


func recompute_hooks_and_max_hooks() -> void:
	bobber.recompute_hooks_and_max_hooks()
