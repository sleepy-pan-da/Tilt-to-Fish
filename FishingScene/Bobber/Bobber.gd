extends KinematicBody2D

class_name Bobber

export(Resource) var bobber_stats = bobber_stats as BobberStats
onready var arrow = $Arrow


func _physics_process(delta : float) -> void:
	move(Input.get_accelerometer())


func move(movement_direction_vector : Vector3) -> void:
	var speed_multiplier : float
	var x_velocity : float
	var y_velocity : float
	var velocity : Vector2
	
	speed_multiplier = compute_speed_multiplier_based_on_tilt_in_x_direction(movement_direction_vector.x)
	x_velocity = movement_direction_vector.x * speed_multiplier 
	speed_multiplier = compute_speed_multiplier_based_on_tilt_in_y_direction(movement_direction_vector.y)
	y_velocity = -movement_direction_vector.y * speed_multiplier 
	velocity = Vector2(x_velocity, y_velocity)
	
	arrow.configure_arrow_location(velocity)
	move_and_slide(velocity)


func compute_speed_multiplier_based_on_tilt_in_x_direction(x_direction_vector : float) -> int:
	# The harder you tilt, the larger the movement direction vector,
	# the larger the speed multiplier
	# the numbers used below will interpolate into an exponential graph
	# --- This method was created to make player not move as much when tilted
	# --- lightly 
	# Thru playtesting, we feel that bobber sensitivity feels higher when moving up than down
	# thus, this function has variants for x direction and y direction
	
	# intervals of 50 - cy
	# intervals of 60 - js
	if abs(x_direction_vector) <= 1: 
		return 300 
	elif abs(x_direction_vector) <= 2:
		return 300
	elif abs(x_direction_vector) <= 3:
		return 300
	elif abs(x_direction_vector) <= 4:
		return 300
	else:
		return 300
				

func compute_speed_multiplier_based_on_tilt_in_y_direction(y_direction_vector : float) -> int:
	if abs(y_direction_vector) <= 1: 
		return 250
	elif abs(y_direction_vector) <= 1.5:
		return 250
	elif abs(y_direction_vector) <= 2:
		return 250
	elif abs(y_direction_vector) <= 2.5:
		return 250
	else:
		return 250
