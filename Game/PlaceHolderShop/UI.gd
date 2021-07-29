extends Control

export(Resource) var bobber_stats = bobber_stats as BobberStats
export(Resource) var backpack = backpack as BackPack
export(String, FILE, "*.tscn") var game_scene 

onready var gold = $Gold
onready var items = $Items
onready var backpack_ui = $Backpack
onready var backpack_items = $Backpack/Items
onready var sell = $Backpack/Sell
onready var screen_transition = $ScreenTransition

func _ready():
	screen_transition.transition_in()
	gold.update_label(bobber_stats.gold_amount)
	backpack_ui.update_backpack_ui(backpack)
	sell.get_child(0).connect("pressed", self, "on_pressed", [0])
	sell.get_child(1).connect("pressed", self, "on_pressed", [1])
	sell.get_child(2).connect("pressed", self, "on_pressed", [2])
	sell.get_child(3).connect("pressed", self, "on_pressed", [3])
	sell.get_child(4).connect("pressed", self, "on_pressed", [4])
	screen_transition.connect("transitioned_out", self, "go_back_to_fishing")


func on_pressed(child_index : int) -> void:
	var corresponding_item_name : String = backpack_items.get_child(child_index).text
	if corresponding_item_name != "":
		backpack.remove_item_from_backpack(corresponding_item_name)
		backpack_ui.update_backpack_ui(backpack)
		# earn money from selling item
		var cost_of_item : int = items.item_pool.get_cost_of_item(corresponding_item_name)
		bobber_stats.increment_gold(cost_of_item)
		gold.update_label(bobber_stats.gold_amount)


func _on_Reroll_pressed():
	if bobber_stats.gold_amount >= 2:
		bobber_stats.decrement_gold(2)
		gold.update_label(bobber_stats.gold_amount)
		items.pick_3_items()


func _on_Item1_pressed():
	update_game_upon_buying_item(0)
		
		

func _on_Item2_pressed():
	update_game_upon_buying_item(1)


func _on_Item3_pressed():
	update_game_upon_buying_item(2)


func update_game_upon_buying_item(button_index : int) -> void:
	var item_text : String = items.get_child(button_index).text
	var item_info : Array = item_text.split(" (")
	var item_name : String = item_info[0]
	
	if item_name == "": # bought the item alr, no more item offered for sale
		return
	
	var item_cost : int = int(item_info[1])
	var can_afford : bool = bobber_stats.gold_amount >= item_cost
	
	if can_afford:
		if backpack.has_space():
			#add item to backpack
			bobber_stats.decrement_gold(item_cost)
			gold.update_label(bobber_stats.gold_amount)
			backpack.add_item(item_name)
			items.get_child(button_index).text = ""
			backpack_ui.update_backpack_ui(backpack)
		elif backpack.has_item(item_name) and !backpack.item_is_maxed_out(item_name):
			#add item to backpack
			bobber_stats.decrement_gold(item_cost)
			gold.update_label(bobber_stats.gold_amount)
			backpack.add_item(item_name)
			items.get_child(button_index).text = ""
			backpack_ui.update_backpack_ui(backpack)
		else:
			return


func _on_NextWave_pressed() -> void:
	screen_transition.transition_out()


func go_back_to_fishing() -> void:
	get_tree().change_scene(game_scene)
