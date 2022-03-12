extends Label


func update_item_type(spawns_orbs : bool) -> void:
	if spawns_orbs:
		text = "- Orb"
	else:
		text = "- Passive"		
