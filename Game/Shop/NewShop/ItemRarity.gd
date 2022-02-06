extends Label


func update_item_rarity(item_rarity_index : int) -> void:
	var item_rarity : String = ItemTraits.RARITY_TYPES.keys()[item_rarity_index]
	text = item_rarity
