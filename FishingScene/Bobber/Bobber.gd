extends KinematicBody2D

class_name Bobber

export(Resource) var bobber_stats = bobber_stats as BobberStats
export(Resource) var backpack = backpack as BackPack
export(Resource) var control_config = control_config as ControlConfig
export(PackedScene) var orbiting_orbs_alpha = orbiting_orbs_alpha as OrbitingOrbsAlpha
export(PackedScene) var orbiting_orbs_gamma = orbiting_orbs_gamma as OrbitingOrbsGamma
onready var arrow = $Arrow
onready var blink_animation_player = $BlinkAnimationPlayer
onready var immunity_timer = $ImmunityTimer
var have_immunity : bool = true 
var immune : bool = false 
var current_orbiting_orbs_alpha : OrbitingOrbsAlpha 
var current_orbiting_orbs_gamma : OrbitingOrbsGamma
signal bobber_entered_scene

func _ready():
	bobber_stats.set_up_initial_stats()
	set_up_damage_stats_based_on_backpack()
	set_up_orbiting_orbs()
	if have_immunity: # will not have_immunity if toggled bobber in the options page
		start_immunity()
	emit_signal("bobber_entered_scene")
	

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


func get_class() -> String:
	return "Bobber"


# this will be called when there's a change in damage multiplier mid game and there's a need to update damage
func update_damage() -> void: 
	bobber_stats.compute_bobber_attack_amount()	
	compute_orbiting_orbs_alpha_damage()
	compute_orbiting_orbs_gamma_damage()

# this will be called when bobber is added to scene
# the items included here influence stats at the start of fishing
func set_up_damage_stats_based_on_backpack() -> void:
	# bobber_attack_amount formula
	# (bobber_attack_amount + flat increase in attack amount) * % increase in attack amount
	
	if backpack.has_item("Heavy Rod"):
		bobber_stats.bobber_attack_rate = 1
		if backpack.item_level("Heavy Rod") == 1:
			bobber_stats.raw_bobber_attack_amount += 20
		elif backpack.item_level("Heavy Rod") == 2:
			bobber_stats.raw_bobber_attack_amount += 40
		else:
			bobber_stats.raw_bobber_attack_amount += 80
			
	if backpack.has_item("Strength"):
		if backpack.item_level("Strength") == 1:
			bobber_stats.raw_bobber_attack_amount *= (1 + 0.25)
		elif backpack.item_level("Strength") == 2:
			bobber_stats.raw_bobber_attack_amount *= (1 + 0.5)
		else:
			bobber_stats.raw_bobber_attack_amount *= (1 + 1)
	
	if backpack.has_item("Live Fast"):		
		if backpack.item_level("Live Fast") == 1:
			bobber_stats.damage_multiplier *= 2
		elif backpack.item_level("Live Fast") == 2:
			bobber_stats.damage_multiplier *= 3
		else:
			bobber_stats.damage_multiplier *= 4
	
	if backpack.has_item("Die Young"):
		if backpack.item_level("Die Young") == 1:
			bobber_stats.damage_multiplier *= 2
		elif backpack.item_level("Die Young") == 2:
			bobber_stats.damage_multiplier *= 3
		else:
			bobber_stats.damage_multiplier *= 4
	
	if backpack.has_item("Enthusiasm"):
		activate_enthusiasm()
	
	if backpack.has_item("Confidence"):
		if backpack.item_level("Confidence") == 1:
			bobber_stats.damage_multiplier *= (1 + (0.4 * bobber_stats.hooks_amount)) 
		elif backpack.item_level("Confidence") == 2:
			bobber_stats.damage_multiplier *= (1 + (0.8 * bobber_stats.hooks_amount)) 
		else:
			bobber_stats.damage_multiplier *= (1 + (1.6 * bobber_stats.hooks_amount)) 
	
	if backpack.has_item("Gravity"):
		bobber_stats.raw_bobber_attack_amount = 0
		if backpack.item_level("Gravity") == 1:
			bobber_stats.damage_multiplier *= (1 + 0.25)
		elif backpack.item_level("Gravity") == 2:
			bobber_stats.damage_multiplier *= (1 + 0.5)
		else:
			bobber_stats.damage_multiplier *= (1 + 1)
	
	print(bobber_stats.bobber_attack_amount)
	bobber_stats.compute_bobber_attack_amount()
	print(bobber_stats.bobber_attack_amount)


func set_up_orbiting_orbs() -> void:
	if backpack.has_item("Orbiting Orbs Alpha"):
		add_orbiting_orbs_alpha_to_bobber()
	if backpack.has_item("Orbiting Orbs Gamma"):
		add_orbiting_orbs_gamma_to_bobber()
	if backpack.has_item("Gravity"):
		update_orbiting_speed()

func add_orbiting_orbs_alpha_to_bobber() -> void:
	current_orbiting_orbs_alpha = orbiting_orbs_alpha.instance()
	compute_orbiting_orbs_alpha_damage()
	add_child(current_orbiting_orbs_alpha)


func compute_orbiting_orbs_alpha_damage() -> void:
	if current_orbiting_orbs_alpha != null:
		if backpack.item_level("Orbiting Orbs Alpha") == 1:
			current_orbiting_orbs_alpha.compute_orb_damage(bobber_stats.damage_multiplier, 5)
		elif backpack.item_level("Orbiting Orbs Alpha") == 2:
			current_orbiting_orbs_alpha.compute_orb_damage(bobber_stats.damage_multiplier, 10)
		else:
			current_orbiting_orbs_alpha.compute_orb_damage(bobber_stats.damage_multiplier, 20)
		current_orbiting_orbs_alpha.set_orb_damage()
		

func add_orbiting_orbs_gamma_to_bobber() -> void:
	current_orbiting_orbs_gamma = orbiting_orbs_gamma.instance()
	compute_orbiting_orbs_gamma_damage()
	add_child(current_orbiting_orbs_gamma)


func compute_orbiting_orbs_gamma_damage() -> void:
	if current_orbiting_orbs_gamma != null:
		if backpack.item_level("Orbiting Orbs Gamma") == 1:
			current_orbiting_orbs_gamma.compute_orb_damage(bobber_stats.damage_multiplier, 2)
		elif backpack.item_level("Orbiting Orbs Gamma") == 2:
			current_orbiting_orbs_gamma.compute_orb_damage(bobber_stats.damage_multiplier, 4)
		else:
			current_orbiting_orbs_gamma.compute_orb_damage(bobber_stats.damage_multiplier, 8)
		current_orbiting_orbs_gamma.set_orb_damage()	


func update_orbiting_speed() -> void:
	if current_orbiting_orbs_alpha != null:
		current_orbiting_orbs_alpha.set_angular_velocity(current_orbiting_orbs_alpha.angular_velocity * 2)
	if current_orbiting_orbs_gamma != null:
		current_orbiting_orbs_gamma.set_angular_velocity(current_orbiting_orbs_gamma.angular_velocity * 4)
			
			
func update_confidence_upon_taking_damage(damage_taken : int) -> void:
	var initial_hook_amount : int = bobber_stats.hooks_amount + damage_taken
	
	if backpack.item_level("Confidence") == 1:
		bobber_stats.damage_multiplier /= (1 + (0.4 * initial_hook_amount))
		bobber_stats.damage_multiplier *= (1 + (0.4 * bobber_stats.hooks_amount))
	elif backpack.item_level("Confidence") == 2:
		bobber_stats.damage_multiplier /= (1 + (0.8 * initial_hook_amount))
		bobber_stats.damage_multiplier *= (1 + (0.8 * bobber_stats.hooks_amount)) 
	else:
		bobber_stats.damage_multiplier /= (1 + (1.6 * initial_hook_amount))
		bobber_stats.damage_multiplier *= (1 + (1.6 * bobber_stats.hooks_amount)) 


func update_confidence_upon_gaining_hook(hook_gained : int) -> void:
	# for this function to work, hooks amount need to be updated in bobber stats first
	var initial_hook_amount : int = bobber_stats.hooks_amount - hook_gained 
	
	if backpack.item_level("Confidence") == 1:
		bobber_stats.damage_multiplier /= (1 + (0.4 * initial_hook_amount))
		bobber_stats.damage_multiplier *= (1 + (0.4 * bobber_stats.hooks_amount))
	elif backpack.item_level("Confidence") == 2:
		bobber_stats.damage_multiplier /= (1 + (0.8 * initial_hook_amount))
		bobber_stats.damage_multiplier *= (1 + (0.8 * bobber_stats.hooks_amount)) 
	else:
		bobber_stats.damage_multiplier /= (1 + (1.6 * initial_hook_amount))
		bobber_stats.damage_multiplier *= (1 + (1.6 * bobber_stats.hooks_amount)) 


func activate_black_mamba() -> void:
	if backpack.item_level("Black Mamba") == 1:
		bobber_stats.damage_multiplier *= (1 + 0.4)
	elif backpack.item_level("Black Mamba") == 2:
		bobber_stats.damage_multiplier *= (1 + 0.8)
	else:
		bobber_stats.damage_multiplier *= (1 + 1.6)


func deactivate_black_mamba() -> void:
	if backpack.item_level("Black Mamba") == 1:
		bobber_stats.damage_multiplier /= (1 + 0.4)
	elif backpack.item_level("Black Mamba") == 2:
		bobber_stats.damage_multiplier /= (1 + 0.8)
	else:
		bobber_stats.damage_multiplier /= (1 + 1.6)


func activate_enthusiasm() -> void:
	if backpack.item_level("Enthusiasm") == 1:
		bobber_stats.damage_multiplier *= (1 + 0.4)
	elif backpack.item_level("Enthusiasm") == 2:
		bobber_stats.damage_multiplier *= (1 + 0.8)
	else:
		bobber_stats.damage_multiplier *= (1 + 1.6)


func deactivate_enthusiasm() -> void:
	if backpack.item_level("Enthusiasm") == 1:
		bobber_stats.damage_multiplier /= (1 + 0.4)
	elif backpack.item_level("Enthusiasm") == 2:
		bobber_stats.damage_multiplier /= (1 + 0.8)
	else:
		bobber_stats.damage_multiplier /= (1 + 1.6)


func can_activate_underdog() -> bool:
	return bobber_stats.hooks_amount == 1 and !bobber_stats.turned_underdog


func activate_underdog() -> void:
	bobber_stats.turned_underdog = true
	if backpack.item_level("Underdog") == 1:
		bobber_stats.damage_multiplier *= 2
	elif backpack.item_level("Underdog") == 2:
		bobber_stats.damage_multiplier *= 3
	else:
		bobber_stats.damage_multiplier *= 4


func can_activate_captain_hook_beta(num_of_fish_caught : int) -> bool:
	return num_of_fish_caught % 5 == 0


func activate_captain_hook_beta() -> void:
	var num_of_hook_gained : int
	if backpack.item_level("Captain Hook Beta") == 1:
		num_of_hook_gained = 1
	elif backpack.item_level("Captain Hook Beta") == 2:
		randomize()
		var luck : int = randi() % 100 # 0-99
		if luck >= 80:
			num_of_hook_gained = 2
		else:
			num_of_hook_gained = 1
	else:
		randomize()
		var luck : int = randi() % 100 # 0-99
		if luck >= 50:
			num_of_hook_gained = 2
		else:
			num_of_hook_gained = 1
	bobber_stats.gain_hook(num_of_hook_gained)
	GameEvents.emit_signal("bobber_gained_hook", num_of_hook_gained)


func activate_captain_hook_alpha() -> void:
	if backpack.item_level("Captain Hook Alpha") == 1:
		bobber_stats.gain_hook(1)
	elif backpack.item_level("Captain Hook Alpha") == 2:
		bobber_stats.gain_hook(2)
	else:
		bobber_stats.gain_hook(3)



