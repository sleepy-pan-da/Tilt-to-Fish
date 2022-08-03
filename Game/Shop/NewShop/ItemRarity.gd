extends RichTextLabel


func update_item_rarity(item_rarity_index : int) -> void:
	var item_rarity : String = ItemTraits.RARITY_TYPES.keys()[item_rarity_index]
	match item_rarity:
		"COMMON":
			bbcode_text = "[right][color=green]Common[/color][/right]"
		"UNCOMMON":
			bbcode_text = "[right][color=teal]Uncommon[/color][/right]"
		"RARE":
			bbcode_text = "[right][color=purple]Rare[/color][/right]"
		_:
			pass
