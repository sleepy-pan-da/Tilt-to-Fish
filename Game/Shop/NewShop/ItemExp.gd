extends Label


func update_item_exp(exp_pts : int) -> void:
	if exp_pts != null:
		text = "Exp: " + str(exp_pts) + "/3"
