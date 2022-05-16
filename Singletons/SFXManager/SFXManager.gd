extends Node

onready var ui = $UI
onready var bobber = $Bobber
onready var fish = $Fish

func play(sfx_name : String) -> void:
	if !sfx_name: return
	get_node(sfx_name).play()
