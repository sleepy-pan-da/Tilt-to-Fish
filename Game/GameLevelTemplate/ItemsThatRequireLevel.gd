extends Node

export(PackedScene) onready var Cccombo

# Orb Spawners
export(PackedScene) onready var Arrow
export(PackedScene) onready var AntimatterWave
export(PackedScene) onready var FiveRoundsRapid
export(PackedScene) onready var FieldMedic
export(PackedScene) onready var StunGrenade


func get_reference(item_name : String) -> PackedScene:
	item_name = item_name.replace(" ", "")
	return get(item_name)
