extends KinematicBody2D

onready var arrow = $Arrow


func _physics_process(delta : float) -> void:
	move(Input.get_accelerometer())


func move(movement_direction_vector : Vector3) -> void:
	var speed_multiplier : float
	var x_velocity : float
	var y_velocity : float
	var velocity : Vector2
	
	speed_multiplier = compute_speed_multiplier_based_on_tilt(movement_direction_vector.x)
	x_velocity = movement_direction_vector.x * speed_multiplier 
	speed_multiplier = compute_speed_multiplier_based_on_tilt(movement_direction_vector.y)
	y_velocity = -movement_direction_vector.y * speed_multiplier 
	velocity = Vector2(x_velocity, y_velocity)
	
	arrow.configure_arrow_location(velocity)
	move_and_slide(velocity)


func compute_speed_multiplier_based_on_tilt(movement_direction_vector : float) -> int:
	# The harder you tilt, the larger the movement direction vector,
	# the larger the speed multiplier
	# the numbers used below will interpolate into an exponential graph
	# --- This method was created to make player not move as much when tilted
	# --- lightly 
	if abs(movement_direction_vector) <= 1: 
		return 125 
	elif abs(movement_direction_vector) <= 2:
		return 175
	elif abs(movement_direction_vector) <= 3:
		return 200
	elif abs(movement_direction_vector) <= 4:
		return 225
	else:
		return 250
