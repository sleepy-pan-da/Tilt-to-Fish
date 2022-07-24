extends Node

export(PackedScene) onready var Cccombo

# Orb Spawners
export(PackedScene) onready var Arrow
export(PackedScene) onready var AntimatterWave
export(PackedScene) onready var FiveRoundsRapid
export(PackedScene) onready var FieldMedic
export(PackedScene) onready var StunGrenade
export(PackedScene) onready var LongRest
export(PackedScene) onready var Invulnerability
export(PackedScene) onready var StickyGoo
export(PackedScene) onready var Mjolnir
export(PackedScene) onready var Acid
export(PackedScene) onready var AtAllCost
export(PackedScene) onready var Thunder
export(PackedScene) onready var CookTheGrenade
export(PackedScene) onready var TNT
export(PackedScene) onready var TimeLordVictorious


func get_reference(item_name : String) -> PackedScene:
	item_name = item_name.replace(" ", "")
	return get(item_name)
