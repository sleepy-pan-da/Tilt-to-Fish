extends HBoxContainer

export(Resource) var fish_index = fish_index as FishIndex

onready var left_grid = $Left/Grid
onready var displayed_fish_info = $Right/DisplayedFishInfo

func _ready():
	populate_fish_buttons()
	GameEvents.connect("pressed_fish_button_in_index", self, "on_pressed_fish_button_in_index")


func populate_fish_buttons() -> void:
	for fish_info in fish_index.fishes:
		left_grid.create_fish_button(fish_info)


func on_pressed_fish_button_in_index(fish_name : String) -> void:
	var fish_info : FishInfo = fish_index.get_fish_info(fish_name)
	displayed_fish_info.update_info(fish_info)
	#print(fish_info.name)
	#print(fish_info.can_touch)
	#print(fish_info.description)
