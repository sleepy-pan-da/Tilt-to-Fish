extends Node2D

export(float) var max_speed : float
export(float) var mass : float
var current_velocity : Vector2

func compute_new_velocity(bobber : Bobber) -> Vector2:
	if bobber != null:
		var desired_velocity_to_bobber : Vector2
		var direction_to_bobber : Vector2 = (bobber.global_position - global_position).normalized()
		desired_velocity_to_bobber = direction_to_bobber * max_speed
		
		if current_velocity == Vector2.ZERO:
			current_velocity = desired_velocity_to_bobber
		
		var significant_angle_diff : bool = abs(rad2deg(direction_to_bobber.angle_to(current_velocity))) >= 5
		if significant_angle_diff:
			var steering_velocity : Vector2 = (desired_velocity_to_bobber - current_velocity) / mass
			current_velocity = current_velocity + steering_velocity
		else:
			current_velocity = desired_velocity_to_bobber
	return current_velocity


func reset_current_velocity() -> void:
	current_velocity = Vector2(0, 0)
