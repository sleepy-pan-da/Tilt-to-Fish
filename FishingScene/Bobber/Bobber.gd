extends KinematicBody2D

class_name Bobber

export(Resource) var bobber_stats = bobber_stats as BobberStats
export(Resource) var backpack = backpack as BackPack
export(Resource) var control_config = control_config as ControlConfig
onready var arrow = $Arrow
onready var blink_animation_player = $BlinkAnimationPlayer
onready var immunity_timer = $ImmunityTimer
var have_immunity : bool = true 
var immune : bool = false 


func _ready():
	bobber_stats.set_up_initial_stats()
	set_up_stats_based_on_upgrades()
	if have_immunity: # will not have_immunity if toggled bobber in the options page
		start_immunity()


func _physics_process(delta : float) -> void:
	move(Input.get_accelerometer())


func move(movement_direction_vector : Vector3) -> void:
	var speed_multiplier : int
	var x_velocity : float
	var y_velocity : float
	var velocity : Vector2
	
	if control_config.holding_preference == "regular":
		movement_direction_vector = recalibrate_regular_movement_direction_vector(movement_direction_vector)
	
	speed_multiplier = compute_speed_multiplier()	
	x_velocity = movement_direction_vector.x * speed_multiplier
	y_velocity = -movement_direction_vector.y * speed_multiplier 
	velocity = Vector2(x_velocity, y_velocity)
	
	arrow.configure_arrow_location(velocity)
	move_and_slide(velocity)


func compute_speed_multiplier() -> int:
	return 2 * control_config.tilt_sensitivity


func recalibrate_regular_movement_direction_vector(movement_direction_vector : Vector3) -> Vector3:
	var y_axis_offset : int = -7
	movement_direction_vector.y -= y_axis_offset # recalibrating movement direction vector, only y axis is changed
	movement_direction_vector.y *= 1.5 # make it easier to move downwards
	movement_direction_vector.x *= 1.5
	return movement_direction_vector


func start_immunity():
	blink_animation_player.play("Immune")
	immune = true
	immunity_timer.start()


func _on_ImmunityTimer_timeout():
	end_immunity()
	

func end_immunity():
	blink_animation_player.play("EndImmune")
	immune = false


func set_up_stats_based_on_upgrades() -> void:
	# bobber_attack_amount formula
	# (bobber_attack_amount + flat increase in attack amount) * % increase in attack amount
	
	if backpack.has_item("Heavy Rod"):
		bobber_stats.bobber_attack_rate = 1
		if backpack.item_level("Heavy Rod") == 1:
			bobber_stats.bobber_attack_amount += 10
		elif backpack.item_level("Heavy Rod") == 2:
			bobber_stats.bobber_attack_amount += 20
		else:
			bobber_stats.bobber_attack_amount += 40
			
	if backpack.has_item("Strength"):
		if backpack.item_level("Strength") == 1:
			bobber_stats.bobber_attack_amount *= (1 + 0.25)
		elif backpack.item_level("Strength") == 2:
			bobber_stats.bobber_attack_amount *= (1 + 0.5)
		else:
			bobber_stats.bobber_attack_amount *= (1 + 1)
	

