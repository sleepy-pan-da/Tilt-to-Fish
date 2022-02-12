extends Label


func update_item_selling_costs(selling_costs : Array) -> void:
	text = "Selling cost: \n" + str(selling_costs[0]) + "/" + str(selling_costs[1]) + "/" + str(selling_costs[2]) 
