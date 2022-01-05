extends KinematicBody2D

class_name Bobber

export(Resource) var bobber_stats = bobber_stats as BobberStats
export(Resource) var backpack = backpack as BackPack
export(Resource) var control_config = control_config as ControlConfig

export(PackedScene) var orbiting_orbs_alpha = orbiting_orbs_alpha as OrbitingOrbsAlpha
export(PackedScene) var orbiting_orbs_gamma = orbiting_orbs_gamma as OrbitingOrbsGamma
export(PackedScene) var intimidation = intimidation as Intimidate
export(PackedScene) var retaliation = retaliation as Retaliation
export(PackedScene) var thrill_seeker = thrill_seeker as ThrillSeeker

export(bool) var testing_on_pc : bool

onready var bobber_sprite = $BobberSprite
onready var arrow = $Arrow
onready var blink_animation_player = $BlinkAnimationPlayer
onready var immunity_timer = $ImmunityTimer
onready var get_excited_timer = $GetExcitedTimer
onready var rejuvenated_timer = $RejuvenatedTimer
onready var long_rest_timer = $LongRestTimer
onready var long_rest_progress_bar = $LongRestProgressBar

var have_immunity : bool = true 
var immune : bool = false 
var rejuvenated : bool = false
var current_orbiting_orbs_alpha : OrbitingOrbsAlpha 
var current_orbiting_orbs_gamma : OrbitingOrbsGamma

signal bobber_entered_scene
signal updated_damage
signal intimidated_fish(intimidation, fish_position)
signal retaliated_fish(retaliation, bobber_position)

func _ready():
	# bobber set up 
	bobber_stats.set_up_initial_stats()
	set_up_damage_multiplier_based_on_backpack()
	set_up_bobber_attack_amount_based_on_backpack()
	set_up_poke_and_pull_out()
	set_up_orbiting_orbs()
	set_up_intimidate()
	set_up_retaliation()
	set_up_thrill_seeker()
	
	if have_immunity: # will not have_immunity if toggled bobber in the options page
		start_immunity()
	emit_signal("bobber_entered_scene")
	

func _physics_process(delta : float) -> void:
	if !testing_on_pc:
		move(Input.get_accelerometer())
	else:
		var vertical_direction : int = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		var horizontal_direction : int =  int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		var speed : float = 500
		var velocity : Vector2 = Vector2(horizontal_direction * speed, vertical_direction * speed)
		arrow.configure_arrow_location(velocity)
		move_and_slide(velocity)

func move(movement_direction_vector : Vector3) -> void:
	var speed_multiplier : int
	var x_velocity : float
	var y_velocity : float
	var velocity : Vector2
	
	if control_config.holding_preference == "regular":
		movement_direction_vector = recalibrate_regular_movement_direction_vector(movement_direction_vector)
	
	speed_multiplier = compute_speed_multiplier()	
	
	if movement_direction_vector.length() > 1:
		x_velocity = movement_direction_vector.x * speed_multiplier
		y_velocity = -movement_direction_vector.y * speed_multiplier 
	else:
		x_velocity = movement_direction_vector.x * speed_multiplier / 2
		y_velocity = -movement_direction_vector.y * speed_multiplier / 2
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
			

func reset_upon_new_run() -> void:
	bobber_stats.reset_when_game_over()
	backpack.backpack.clear()
	
	
# UPGRADES!!!
func start_rejuvenated(duration_of_rejuvenation : int) -> void:
	bobber_sprite.set_rejuvenated()
	rejuvenated = true
	rejuvenated_timer.start(duration_of_rejuvenation)


func _on_RejuvenatedTimer_timeout() -> void:
	end_rejuvenated()


func end_rejuvenated() -> void:
	bobber_sprite.reset()
	rejuvenated = false


func start_long_rest(duration_of_long_rest : int) -> void:
	long_rest_timer.start(duration_of_long_rest)
	long_rest_progress_bar.set_up_progress_bar()
	

func _on_LongRestTimer_timeout():
	var number_of_hooks_to_gain = bobber_stats.max_hooks_amount - bobber_stats.hooks_amount
	if number_of_hooks_to_gain > 0:
		bobber_stats.gain_hook(number_of_hooks_to_gain)
	
	
func get_class() -> String:
	return "Bobber"


# this will be called when there's a change in damage multiplier mid game and there's a need to update damage
func update_damage() -> void: 
	bobber_stats.compute_bobber_attack_amount()	
	compute_orbiting_orbs_alpha_damage()
	compute_orbiting_orbs_gamma_damage()
	set_up_poke_and_pull_out()
	set_up_intimidate()
	set_up_retaliation()
	emit_signal("updated_damage")


# this needs to be called first in ready() before setting up other stats
func set_up_damage_multiplier_based_on_backpack() -> void:
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
	bobber_stats.die_young = backpack.has_item("Die Young")
	
	if backpack.has_item("Enthusiasm"):
		activate_enthusiasm()
	
	if backpack.has_item("Confidence"):
		if backpack.item_level("Confidence") == 1:
			bobber_stats.damage_multiplier *= (1 + (0.2 * bobber_stats.hooks_amount)) 
		elif backpack.item_level("Confidence") == 2:
			bobber_stats.damage_multiplier *= (1 + (0.4 * bobber_stats.hooks_amount)) 
		else:
			bobber_stats.damage_multiplier *= (1 + (0.8 * bobber_stats.hooks_amount)) 


func set_up_bobber_attack_amount_based_on_backpack() -> void:
	# How is bobber_attack_amount computed?
	# raw_bobber_attack_amount = (bobber_attack_amount + flat attack amount) * % increase in attack amount 
	# bobber_attack_amount = raw_bobber_attack_amount * damage_multiplier
	
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
	
	if backpack.has_item("Gravity"):
		bobber_stats.raw_bobber_attack_amount = 0
		
	bobber_stats.compute_bobber_attack_amount()
	
	
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
		var orb_damage_multiplier : float
		var total_damage_multiplier : float = bobber_stats.damage_multiplier
		
		if backpack.has_item("Gravity"):
			orb_damage_multiplier = compute_gravity_orb_damage_multiplier()
			total_damage_multiplier *= orb_damage_multiplier
			
		if backpack.item_level("Orbiting Orbs Alpha") == 1:
			current_orbiting_orbs_alpha.compute_orb_damage(total_damage_multiplier, 5)
		elif backpack.item_level("Orbiting Orbs Alpha") == 2:
			current_orbiting_orbs_alpha.compute_orb_damage(total_damage_multiplier, 10)
		else:
			current_orbiting_orbs_alpha.compute_orb_damage(total_damage_multiplier, 20)
		current_orbiting_orbs_alpha.set_orb_damage()


func add_orbiting_orbs_gamma_to_bobber() -> void:
	current_orbiting_orbs_gamma = orbiting_orbs_gamma.instance()
	compute_orbiting_orbs_gamma_damage()
	add_child(current_orbiting_orbs_gamma)


func compute_orbiting_orbs_gamma_damage() -> void:
	if current_orbiting_orbs_gamma != null:
		var orb_damage_multiplier : float
		var total_damage_multiplier : float = bobber_stats.damage_multiplier
		
		if backpack.has_item("Gravity"):
			orb_damage_multiplier = compute_gravity_orb_damage_multiplier()
			total_damage_multiplier *= orb_damage_multiplier
		
		if backpack.item_level("Orbiting Orbs Gamma") == 1:
			current_orbiting_orbs_gamma.compute_orb_damage(total_damage_multiplier, 2)
		elif backpack.item_level("Orbiting Orbs Gamma") == 2:
			current_orbiting_orbs_gamma.compute_orb_damage(total_damage_multiplier, 4)
		else:
			current_orbiting_orbs_gamma.compute_orb_damage(total_damage_multiplier, 8)
		current_orbiting_orbs_gamma.set_orb_damage()	


func update_orbiting_speed() -> void:
	if current_orbiting_orbs_alpha != null:
		current_orbiting_orbs_alpha.set_angular_velocity(current_orbiting_orbs_alpha.angular_velocity * 2)
	if current_orbiting_orbs_gamma != null:
		current_orbiting_orbs_gamma.set_angular_velocity(current_orbiting_orbs_gamma.angular_velocity * 2)


func compute_gravity_orb_damage_multiplier() -> float:
	if backpack.item_level("Gravity") == 1:
		return (1 + 0.25)
	elif backpack.item_level("Gravity") == 2:
		return (1 + 0.5)
	else:
		return (1 + 1.0) 


func update_confidence_upon_taking_damage(damage_taken : int) -> void:
	var initial_hook_amount : int = bobber_stats.hooks_amount + damage_taken
	compute_confidence_damage_multiplier(initial_hook_amount)


func update_confidence_upon_gaining_hook(hook_gained : int) -> void:
	# for this function to work, hooks amount need to be updated in bobber stats first
	var initial_hook_amount : int = bobber_stats.hooks_amount - hook_gained 
	compute_confidence_damage_multiplier(initial_hook_amount)


func compute_confidence_damage_multiplier(initial_hook_amount : int) -> void:
	if backpack.item_level("Confidence") == 1:
		bobber_stats.damage_multiplier /= (1 + (0.2 * initial_hook_amount))
		bobber_stats.damage_multiplier *= (1 + (0.2 * bobber_stats.hooks_amount))
	elif backpack.item_level("Confidence") == 2:
		bobber_stats.damage_multiplier /= (1 + (0.4 * initial_hook_amount))
		bobber_stats.damage_multiplier *= (1 + (0.4 * bobber_stats.hooks_amount)) 
	else:
		bobber_stats.damage_multiplier /= (1 + (0.8 * initial_hook_amount))
		bobber_stats.damage_multiplier *= (1 + (0.8 * bobber_stats.hooks_amount)) 


func activate_black_mamba() -> void:
	if backpack.item_level("Black Mamba") == 1:
		bobber_stats.damage_multiplier *= (1 + 0.5)
	elif backpack.item_level("Black Mamba") == 2:
		bobber_stats.damage_multiplier *= (1 + 1)
	else:
		bobber_stats.damage_multiplier *= (1 + 2)


func deactivate_black_mamba() -> void:
	if backpack.item_level("Black Mamba") == 1:
		bobber_stats.damage_multiplier /= (1 + 0.5)
	elif backpack.item_level("Black Mamba") == 2:
		bobber_stats.damage_multiplier /= (1 + 1)
	else:
		bobber_stats.damage_multiplier /= (1 + 2)


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
		bobber_stats.damage_multiplier *= 3
	elif backpack.item_level("Underdog") == 2:
		bobber_stats.damage_multiplier *= 4
	else:
		bobber_stats.damage_multiplier *= 5


func can_activate_captain_hook_beta(num_of_fish_caught : int) -> bool:
	return num_of_fish_caught % 7 == 0


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


func activate_captain_hook_alpha() -> void:
	if backpack.item_level("Captain Hook Alpha") == 1:
		bobber_stats.gain_hook(1)
	elif backpack.item_level("Captain Hook Alpha") == 2:
		bobber_stats.gain_hook(2)
	else:
		bobber_stats.gain_hook(3)


func set_up_poke_and_pull_out() -> void:
	if backpack.has_item("Poke"):
		activate_poke()
	else:
		deactivate_poke()
	
	if backpack.has_item("Pull Out"):
		activate_pull_out()
	else:
		deactivate_pull_out()


func activate_poke() -> void:
	if backpack.item_level("Poke") == 1:
		bobber_stats.compute_poke_damage(5)
	elif backpack.item_level("Poke") == 2:
		bobber_stats.compute_poke_damage(10)
	else:
		bobber_stats.compute_poke_damage(20)


func deactivate_poke() -> void:
	bobber_stats.compute_poke_damage(0)


func activate_pull_out() -> void:
	if backpack.item_level("Pull Out") == 1:
		bobber_stats.compute_pull_out_damage(5)
	elif backpack.item_level("Pull Out") == 2:
		bobber_stats.compute_pull_out_damage(10)
	else:
		bobber_stats.compute_pull_out_damage(20)


func deactivate_pull_out() -> void:
	bobber_stats.compute_pull_out_damage(0)


func set_up_intimidate() -> void:
	if backpack.has_item("Intimidate"):
		activate_intimidate()
	else:
		deactivate_intimidate()


func activate_intimidate() -> void:
	if backpack.item_level("Intimidate") == 1:
		bobber_stats.compute_intimidate_damage(10)
	elif backpack.item_level("Intimidate") == 2:
		bobber_stats.compute_intimidate_damage(20)
	else:
		bobber_stats.compute_intimidate_damage(40)


func deactivate_intimidate() -> void:
	bobber_stats.compute_intimidate_damage(0)


func instantiate_intimidate(fish_position : Vector2) -> void:
	var current_intimidation = intimidation.instance()
	current_intimidation.set_damage(bobber_stats.intimidate_damage)
	emit_signal("intimidated_fish", current_intimidation, fish_position)


func set_up_retaliation() -> void:
	if backpack.has_item("Retaliation"):
		activate_retaliation()
	else:
		deactivate_retaliation()


func activate_retaliation() -> void:
	if backpack.item_level("Retaliation") == 1:
		bobber_stats.compute_retaliate_damage(15)
	elif backpack.item_level("Retaliation") == 2:
		bobber_stats.compute_retaliate_damage(30)
	else:
		bobber_stats.compute_retaliate_damage(60)


func deactivate_retaliation() -> void:
	bobber_stats.compute_retaliate_damage(0)


func instantiate_retaliation() -> void:
	var current_retaliation = retaliation.instance()
	current_retaliation.set_damage(bobber_stats.retaliate_damage)
	emit_signal("retaliated_fish", current_retaliation, global_position)
	

func update_reassuring_confidence_upon_catching_fish() -> void:
	var initial_reassuring_confidence_stacks : int = bobber_stats.reassuring_confidence_stacks
	if bobber_stats.reassuring_confidence_stacks < 10:
		bobber_stats.reassuring_confidence_stacks += 1
	compute_reassuring_confidence_damage_multiplier(initial_reassuring_confidence_stacks)


func update_reassuring_confidence_upon_taking_damage() -> void:
	var initial_reassuring_confidence_stacks : int = bobber_stats.reassuring_confidence_stacks
	bobber_stats.reassuring_confidence_stacks /= 2
	compute_reassuring_confidence_damage_multiplier(initial_reassuring_confidence_stacks)


func compute_reassuring_confidence_damage_multiplier(initial_reassuring_confidence_stacks : int) -> void:
	if backpack.item_level("Reassuring Confidence") == 1:
		bobber_stats.damage_multiplier /= (1 + (0.2 * initial_reassuring_confidence_stacks))
		bobber_stats.damage_multiplier *= (1 + (0.2 * bobber_stats.reassuring_confidence_stacks))
	elif backpack.item_level("Reassuring Confidence") == 2:
		bobber_stats.damage_multiplier /= (1 + (0.4 * initial_reassuring_confidence_stacks))
		bobber_stats.damage_multiplier *= (1 + (0.4 * bobber_stats.reassuring_confidence_stacks))
	else:
		bobber_stats.damage_multiplier /= (1 + (0.8 * initial_reassuring_confidence_stacks))
		bobber_stats.damage_multiplier *= (1 + (0.8 * bobber_stats.reassuring_confidence_stacks))


func update_masochistic() -> void:
	var initial_masochistic_stacks : int = bobber_stats.masochistic_stacks
	bobber_stats.masochistic_stacks += 1
	compute_masochistic_damage_multiplier(initial_masochistic_stacks)


func compute_masochistic_damage_multiplier(initial_masochistic_stacks : int):
	if backpack.item_level("Masochistic") == 1:
		bobber_stats.damage_multiplier /= (1 + (0.3 * initial_masochistic_stacks))
		bobber_stats.damage_multiplier *= (1 + (0.3 * bobber_stats.masochistic_stacks))
	elif backpack.item_level("Masochistic") == 2:
		bobber_stats.damage_multiplier /= (1 + (0.6 * initial_masochistic_stacks))
		bobber_stats.damage_multiplier *= (1 + (0.6 * bobber_stats.masochistic_stacks))
	else:
		bobber_stats.damage_multiplier /= (1 + (1.2 * initial_masochistic_stacks))
		bobber_stats.damage_multiplier *= (1 + (1.2 * bobber_stats.masochistic_stacks))


func get_excited() -> void:
	if get_excited_timer.is_stopped():
		if backpack.item_level("Get Excited") == 1:
			bobber_stats.damage_multiplier *= (1 + 2)
		elif backpack.item_level("Get Excited") == 2:
			bobber_stats.damage_multiplier *= (1 + 3)
		else:
			bobber_stats.damage_multiplier *= (1 + 4)
	get_excited_timer.start()	# resets the get_excited buff if get_excited_timer is still runnning


func _on_GetExcitedTimer_timeout() -> void:
	no_longer_excited()


func no_longer_excited() -> void:
	if backpack.item_level("Get Excited") == 1:
		bobber_stats.damage_multiplier /= (1 + 2)
	elif backpack.item_level("Get Excited") == 2:
		bobber_stats.damage_multiplier /= (1 + 3)
	else:
		bobber_stats.damage_multiplier /= (1 + 4)
	update_damage()


func set_up_thrill_seeker() -> void:
	if backpack.has_item("Thrill Seeker"):
		var current_thrill_seeker : ThrillSeeker = thrill_seeker.instance()
		add_child(current_thrill_seeker)
		current_thrill_seeker.connect("activated_thrill_seeker", self, "update_thrill_seeker_when_near_hitbox")
	
	
func update_thrill_seeker_when_near_hitbox() -> void:
	bobber_sprite.react()
	var initial_thrill_stacks : int = bobber_stats.thrill_seeker_stacks
	if bobber_stats.thrill_seeker_stacks < 10:
		bobber_stats.thrill_seeker_stacks += 1
	compute_thrill_seeker_damage_multiplier(initial_thrill_stacks)
	update_damage()


func reset_thrill_seeker_upon_taking_damage() -> void:
	var initial_thrill_stacks : int = bobber_stats.thrill_seeker_stacks
	bobber_stats.thrill_seeker_stacks = 0
	compute_thrill_seeker_damage_multiplier(initial_thrill_stacks)
	

func compute_thrill_seeker_damage_multiplier(initial_thrill_stacks : int) -> void:
	if backpack.item_level("Thrill Seeker") == 1:
		bobber_stats.damage_multiplier /= (1 + (0.3 * initial_thrill_stacks))
		bobber_stats.damage_multiplier *= (1 + (0.3 * bobber_stats.thrill_seeker_stacks))
	elif backpack.item_level("Thrill Seeker") == 2:
		bobber_stats.damage_multiplier /= (1 + (0.6 * initial_thrill_stacks))
		bobber_stats.damage_multiplier *= (1 + (0.6 * bobber_stats.thrill_seeker_stacks))
	else:
		bobber_stats.damage_multiplier /= (1 + (1.2 * initial_thrill_stacks))
		bobber_stats.damage_multiplier *= (1 + (1.2 * bobber_stats.thrill_seeker_stacks))		


func update_pumping_iron() -> void:
	var initial_iron_stacks = bobber_stats.pumping_iron_stacks
	bobber_stats.pumping_iron_stacks += 1
	compute_pumping_iron_damage_multiplier(initial_iron_stacks)
	update_damage()


func compute_pumping_iron_damage_multiplier(initial_iron_stacks : int) -> void:
	if backpack.item_level("Pumping Iron") == 1:
		bobber_stats.damage_multiplier /= (1 + (0.05 * initial_iron_stacks))
		bobber_stats.damage_multiplier *= (1 + (0.05 * bobber_stats.pumping_iron_stacks))
	elif backpack.item_level("Pumping Iron") == 2:
		bobber_stats.damage_multiplier /= (1 + (0.1 * initial_iron_stacks))
		bobber_stats.damage_multiplier *= (1 + (0.1 * bobber_stats.pumping_iron_stacks))
	else:
		bobber_stats.damage_multiplier /= (1 + (0.2 * initial_iron_stacks))
		bobber_stats.damage_multiplier *= (1 + (0.2 * bobber_stats.pumping_iron_stacks))
