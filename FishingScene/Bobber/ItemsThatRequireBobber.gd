extends Node

export(PackedScene) onready var BulletTime

# Orbs
export(PackedScene) onready var Arrow
export(PackedScene) onready var AntimatterWave

func get_reference(item_name : String) -> PackedScene:
	item_name = item_name.replace(" ", "")
	return get(item_name)
