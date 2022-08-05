extends RichTextLabel


func update_item_selling_costs(selling_costs : Array, item_level : int) -> void:
	match item_level:
		1:
			bbcode_text = "Selling cost: \n[color=green]%d[/color]/%d/%d" % selling_costs
		2:
			bbcode_text = "Selling cost: \n%d/[color=green]%d[/color]/%d" % selling_costs
		3:
			bbcode_text = "Selling cost: \n%d/%d/[color=green]%d[/color]" % selling_costs
		_:
			bbcode_text + "invalid item level"
