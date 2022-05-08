extends Area2D

const slow_by : float = 0.5

func set_value(new_value) -> void:
	scale = Vector2(new_value, new_value)


# for fish
func _on_BulletTime_body_entered(body): 
	var state_machine : StateMachine = body.get_node_or_null("StateMachine")
	if state_machine:
		state_machine.slow_multiplier = max(state_machine.slow_multiplier - slow_by, 0.1)


func _on_BulletTime_body_exited(body): 
	var state_machine : StateMachine = body.get_node_or_null("StateMachine")
	if state_machine:
		state_machine.slow_multiplier = max(state_machine.slow_multiplier + slow_by, 0.1)


# for projectiles
func _on_BulletTime_area_entered(area): 
	if "slow_multiplier" in area:
		area.slow_multiplier = max(area.slow_multiplier - slow_by, 0.1)


func _on_BulletTime_area_exited(area):
	if "slow_multiplier" in area:
		area.slow_multiplier = max(area.slow_multiplier + slow_by, 0.1)
