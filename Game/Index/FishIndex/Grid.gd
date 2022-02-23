extends GridContainer

export(PackedScene) var fish_button


func create_fish_button(fish_info : FishInfo) -> void:
	var new_fish_button = fish_button.instance()
	new_fish_button.texture_normal = fish_info.sprite
	new_fish_button.fish_name = fish_info.name
	add_child(new_fish_button)
