extends Label


func update_item_exp(exp_pts : int) -> void:
	if exp_pts != null:
		if exp_pts <= 1:
			text = "Exp: " + str(exp_pts) + "/2"
		else:
			text = "Exp: " + str(exp_pts-2) + "/4"
