extends VBoxContainer

onready var sprite = $Sprite
onready var fish_name = $Name
onready var description = $Description
onready var hostile = $Hostile

func update_info(fish_info : FishInfo) -> void:
	sprite.texture = fish_info.sprite
	fish_name.text = fish_info.name
	description.text = fish_info.description
	hostile.update_label(fish_info.can_touch)
