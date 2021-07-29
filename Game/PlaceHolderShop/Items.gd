extends HBoxContainer

export(Resource) var item_pool = item_pool as ItemPool
onready var item_1 = $Item1
onready var item_2 = $Item2
onready var item_3 = $Item3

func _ready():
	pick_3_items()


func pick_3_items() -> void:
	for i in range(3):
		var item_picked : String = item_pool.pick_an_item()
		get_child(i).text = item_picked
	
