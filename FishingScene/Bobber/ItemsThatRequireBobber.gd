extends Node

export(PackedScene) onready var BulletTime
export(PackedScene) onready var Retaliation

# Orbs
export(PackedScene) onready var Arrow
export(PackedScene) onready var AntimatterWave
export(PackedScene) onready var LongRest
export(PackedScene) onready var Invulnerability
export(PackedScene) onready var Acid

# Proximity Area Timers
export(PackedScene) onready var PlasmaField
export(PackedScene) onready var Intimidate

func get_reference(item_name : String) -> PackedScene:
	item_name = item_name.replace(" ", "")
	return get(item_name)
