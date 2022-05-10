extends KinematicBody2D

class_name Bobber

export(Resource) var bobber_stats = bobber_stats as BobberStats
export(Resource) var backpack = backpack as BackPack
export(Resource) var item_pool = item_pool as ItemPool
export(Resource) var control_config = control_config as ControlConfig

export(bool) var testing_on_pc : bool

onready var bobber_sprite = $BobberSprite
onready var arrow = $Arrow
onready var blink_animation_player = $BlinkAnimationPlayer
onready var immunity_timer = $ImmunityTimer
onready var items_that_require_bobber = $ItemsThatRequireBobber
onready var proximity_area_timers = $ProximityAreaTimers

# variables that have to do with movement
const ACCELERATION := 8000
const MAX_SPEED := 1500
var current_velocity : Vector2

var have_immunity : bool = true 
var is_immune : int = 0 # int instead of bool to allow multiple triggers of invulnerability orb
var is_moving : bool = false
var no_of_proximity_areas_in : int = 0
var immunity_stacks_to_be_removed : int = 0
signal bobber_entered_scene


func call_when_instantiated() -> void:
	bobber_stats.set_up_initial_stats()
	set_up_stats_at_start_of_fishing()
	override_stats_at_start_of_fishing()


func _ready():
	if have_immunity: # will not have_immunity if toggled bobber in the options page
		start_immunity()
	emit_signal("bobber_entered_scene")
	GameEvents.connect("set_up_bobber_item_at_start_of_fishing", self, "on_set_up_bobber_item_at_start_of_fishing")
	GameEvents.connect("set_up_bobber_proximity_area_timers_at_start_of_fishing", self, "on_set_up_bobber_proximity_area_timers_at_start_of_fishing")
	GameEvents.connect("triggered_orb_that_requires_bobber", self, "on_triggered_orb_that_requires_bobber")
	GameEvents.connect("triggered_item_that_requires_bobber", self, "on_triggered_item_that_requires_bobber")
	set_up_items_at_start_of_fishing()


func on_set_up_bobber_item_at_start_of_fishing(item_name : String, incremented_values) -> void:
	var triggered_item = items_that_require_bobber.get_reference(item_name)
	var triggered_instance = triggered_item.instance()
	add_child(triggered_instance)
	triggered_instance.set_value(incremented_values)
	
	if item_name == "Bullet Time":
		pass


func on_set_up_bobber_proximity_area_timers_at_start_of_fishing(item_name : String, incremented_values) -> void:
	var triggered_item = items_that_require_bobber.get_reference(item_name)
	var triggered_instance = triggered_item.instance()
	triggered_instance.set_value(incremented_values)
	proximity_area_timers.add_child(triggered_instance)


func on_triggered_orb_that_requires_bobber(item_name : String, incremented_values) -> void:
	if item_name == "TNT" and has_node("TNT"):
		get_node("TNT").update_qty_from_orb(incremented_values)
		return
	
	var triggered_item = items_that_require_bobber.get_reference(item_name)
	var triggered_instance = triggered_item.instance()
	call_deferred("add_child", triggered_instance)
	triggered_instance.call_deferred("set_incremented_values", incremented_values)
	
	if item_name == "Arrow" or item_name == "Antimatter Wave":
		triggered_instance.set_bobber_reference(self)
	if item_name == "TNT":
		triggered_instance.name = item_name
		


func on_triggered_item_that_requires_bobber(item_name : String, incremented_values) -> void:
	var triggered_item = items_that_require_bobber.get_reference(item_name)
	var triggered_instance = triggered_item.instance()
	call_deferred("add_child", triggered_instance)
	triggered_instance.call_deferred("set_value", incremented_values)


func _physics_process(delta : float) -> void:
	if !testing_on_pc:
		move(Input.get_accelerometer(), delta)
	else:
		var vertical_direction : int = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		var horizontal_direction : int =  int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		
		is_moving = !(vertical_direction == 0 and horizontal_direction == 0)
		
		var speed : float = 500
		var velocity : Vector2 = Vector2(horizontal_direction * speed, vertical_direction * speed)
		arrow.configure_arrow_location(velocity)
		move_and_slide(velocity)
	
	if backpack.has_item("Time Lord Victorious"):
		if is_moving:
			Engine.time_scale = 1.0
			if bobber_stats.previous_reel_damage > 0:
				bobber_stats.reel_damage = bobber_stats.previous_reel_damage
				bobber_stats.previous_reel_damage = 0
		else:
			Engine.time_scale = bobber_stats.slows_down_time_by
			if bobber_stats.previous_reel_damage == 0:
				bobber_stats.previous_reel_damage = bobber_stats.reel_damage 
				bobber_stats.reel_damage = 0
	else:
		Engine.time_scale = 1.0


func move(accelerometer_vector : Vector3, delta : float) -> void:
	var speed_multiplier : int
	var desired_velocity : Vector2
	
	if control_config.holding_preference == "regular":
		accelerometer_vector = recalibrate_regular_movement_direction_vector(accelerometer_vector)
	
	speed_multiplier = compute_speed_multiplier()	
	
	desired_velocity =  Vector2(accelerometer_vector.x, accelerometer_vector.y)
	
	if desired_velocity.length() > 0.5:
		desired_velocity.x = desired_velocity.x * speed_multiplier
		desired_velocity.y = -desired_velocity.y * speed_multiplier 
		is_moving = true
	else:
		desired_velocity.x = desired_velocity.x * speed_multiplier / 2
		desired_velocity.y = -desired_velocity.y * speed_multiplier / 2
		is_moving = false
	
	arrow.configure_arrow_location(desired_velocity)
	if desired_velocity.length() > MAX_SPEED:
		desired_velocity = desired_velocity.normalized() * MAX_SPEED
	current_velocity = current_velocity.move_toward(desired_velocity, ACCELERATION * delta)
	move_and_slide(current_velocity)


func compute_speed_multiplier() -> int:
	return 2 * control_config.tilt_sensitivity


func recalibrate_regular_movement_direction_vector(accelerometer_vector : Vector3) -> Vector3:
	var y_axis_offset : int = -7
	accelerometer_vector.y -= y_axis_offset # recalibrating movement direction vector, only y axis is changed
	accelerometer_vector.y *= 1.5 # make it easier to move downwards
	accelerometer_vector.x *= 1.5
	return accelerometer_vector


func start_immunity():
	# You cannot start immunity if you are currently in Invulnerable or EndInvulnerable animation
	if blink_animation_player.current_animation == "Invulnerable" or blink_animation_player.current_animation == "EndInvulnerable":
		return
	blink_animation_player.play("Immune")
	change_immune_stack_by(1)
	
	# This var is needed to keep track of the immunity stacks to be removed.
	# This is due to the scenario where this function is triggered on top of itself.
	# e.g. taking damage and calling this function right before a new wave which also triggers this function.
	# This causes a scenario where if not for this var, when immunity timer times out, only one immunity stack is removed,
	# causing is_immune > 0, making u forever immune for that round.
	# This problem is unique and different compared to invulnerability power up as that one has multiple independent timers managing it as compared
	# to this which only has one
	immunity_stacks_to_be_removed += 1 
	
	immunity_timer.start()


func _on_ImmunityTimer_timeout():
	end_immunity()


func end_immunity():
	if blink_animation_player.current_animation != "Invulnerable" or blink_animation_player.current_animation != "EndInvulnerable":
		blink_animation_player.play("EndImmune")
	change_immune_stack_by(-immunity_stacks_to_be_removed)
	immunity_stacks_to_be_removed = 0


func change_immune_stack_by(change : int) -> void:
	#print("Immune stack: " + str(is_immune) + " -> " + str(is_immune + change))
	is_immune += change
	

func change_num_of_proximity_areas_in_by(change : int) -> void:
	var original_no_of_proximity_areas_in = no_of_proximity_areas_in
	no_of_proximity_areas_in += change
	if no_of_proximity_areas_in < 0:
		no_of_proximity_areas_in = 0

	if original_no_of_proximity_areas_in == 0 and no_of_proximity_areas_in > 0:
		proximity_area_timers.resume_all_timers()
	elif no_of_proximity_areas_in == 0:
		proximity_area_timers.pause_all_timers()
	#print("no_of_proximity_areas_in changed from " + str(original_no_of_proximity_areas_in) + " to " + str(no_of_proximity_areas_in))


func reset_upon_new_run() -> void:
	bobber_stats.reset_when_game_over()
	backpack.held_items.clear()
	

func get_class() -> String:
	return "Bobber"


func set_up_stats_at_start_of_fishing() -> void:
	# Iterate through backpack dictionary to check for any items that require
	# setting up of stats at start of fishing
	for item_name in backpack.held_items:
		var item_traits : ItemTraits = item_pool.get_item(item_name)
		if item_traits.modifies_stats_at_start_of_fishing:
			var item_level : int = backpack.get_item_level(item_name)
			var item_specifications : ItemSpecification = ItemDatabase.get_node(item_name)
			item_specifications.trigger(item_level, ItemSpecification.TRIGGER_CAUSES.set_up_stats_at_start_of_fishing)
	# you need this in the scenario where u sell an item that increases max hooks
	if bobber_stats.hooks_amount > bobber_stats.max_hooks_amount:
		bobber_stats.reconfigure_hook()
		

func override_stats_at_start_of_fishing() -> void:
	for item_name in backpack.held_items:
		var item_traits : ItemTraits = item_pool.get_item(item_name)
		if item_traits.overrides_stats_at_start_of_fishing:
			var item_level : int = backpack.get_item_level(item_name)
			var item_specifications : ItemSpecification = ItemDatabase.get_node(item_name)
			item_specifications.trigger(item_level, ItemSpecification.TRIGGER_CAUSES.override_stats_at_start_of_fishing)
	if bobber_stats.hooks_amount > bobber_stats.max_hooks_amount:
		bobber_stats.reconfigure_hook()


# items that are visible on the bobber like BulletTime
# only called when bobber is ready()
func set_up_items_at_start_of_fishing() -> void:
	for item_name in backpack.held_items:
		var item_traits : ItemTraits = item_pool.get_item(item_name)
		if item_traits.set_up_bobber_item_at_start_of_fishing:
			var item_level : int = backpack.get_item_level(item_name)
			var item_specifications : ItemSpecification = ItemDatabase.get_node(item_name)
			item_specifications.trigger(item_level, ItemSpecification.TRIGGER_CAUSES.set_up_bobber_item_at_start_of_fishing)


func on_lost_all_hooks() -> void:
	for item_name in backpack.held_items:
		var item_traits : ItemTraits = item_pool.get_item(item_name)
		if item_traits.triggers_when_lose_all_hooks:
			var item_level : int = backpack.get_item_level(item_name)
			var item_specifications : ItemSpecification = ItemDatabase.get_node(item_name)
			item_specifications.trigger(item_level, ItemSpecification.TRIGGER_CAUSES.lost_all_hooks)
	if bobber_stats.hooks_amount > bobber_stats.max_hooks_amount:
		bobber_stats.reconfigure_hook()


func on_caught_fish() -> void:
	for item_name in backpack.held_items:
		var item_traits : ItemTraits = item_pool.get_item(item_name)
		if item_traits.triggers_when_catch_fish:
			var item_level : int = backpack.get_item_level(item_name)
			var item_specifications : ItemSpecification = ItemDatabase.get_node(item_name)
			item_specifications.trigger(item_level, ItemSpecification.TRIGGER_CAUSES.caught_fish)
	if bobber_stats.hooks_amount > bobber_stats.max_hooks_amount:
		bobber_stats.reconfigure_hook()


func on_lost_hook() -> void:
	for item_name in backpack.held_items:
		var item_traits : ItemTraits = item_pool.get_item(item_name)
		if item_traits.triggers_when_lose_hook:
			var item_level : int = backpack.get_item_level(item_name)
			var item_specifications : ItemSpecification = ItemDatabase.get_node(item_name)
			item_specifications.trigger(item_level, ItemSpecification.TRIGGER_CAUSES.lost_hook)


func on_entered_proximity_area_of_stunned_fish() -> void:
	for item_name in backpack.held_items:
		var item_traits : ItemTraits = item_pool.get_item(item_name)
		if item_traits.triggers_when_enter_proximity_area_of_stunned_fish:
			var item_level : int = backpack.get_item_level(item_name)
			var item_specifications : ItemSpecification = ItemDatabase.get_node(item_name)
			item_specifications.trigger(item_level, ItemSpecification.TRIGGER_CAUSES.entered_proximity_area)


func on_entered_proximity_area() -> void:
	for item_name in backpack.held_items:
		var item_traits : ItemTraits = item_pool.get_item(item_name)
		if item_traits.triggers_when_enter_proximity_area:
			if item_name == "Against All Odds" and no_of_proximity_areas_in < 3:
				return
			var item_level : int = backpack.get_item_level(item_name)
			var item_specifications : ItemSpecification = ItemDatabase.get_node(item_name)
			item_specifications.trigger(item_level, ItemSpecification.TRIGGER_CAUSES.entered_proximity_area)


func set_up_orb_spawners_at_start_of_fishing() -> void:
	for item_name in backpack.held_items:
		var item_traits : ItemTraits = item_pool.get_item(item_name)
		if item_traits.spawns_orbs:
			var item_level : int = backpack.get_item_level(item_name)
			var item_specifications : ItemSpecification = ItemDatabase.get_node(item_name)
			item_specifications.trigger(item_level, ItemSpecification.TRIGGER_CAUSES.set_up_orb_spawners_at_start_of_fishing)


func on_visit_shop() -> void:
	for item_name in backpack.held_items:
		var item_traits : ItemTraits = item_pool.get_item(item_name)
		if item_traits.triggers_when_visit_shop:
			var item_level : int = backpack.get_item_level(item_name)
			var item_specifications : ItemSpecification = ItemDatabase.get_node(item_name)
			item_specifications.trigger(item_level, ItemSpecification.TRIGGER_CAUSES.visited_shop)


func on_buy_item(item_name : String) -> void:
	var item_traits : ItemTraits = item_pool.get_item(item_name)
	if item_traits.triggers_when_bought:
		var item_level : int = 1	# items start at this level
		var item_specifications : ItemSpecification = ItemDatabase.get_node(item_name)
		item_specifications.trigger(item_level, ItemSpecification.TRIGGER_CAUSES.bought_this_item)


func on_sell_item(item_name : String, item_level : int) -> void:
	var item_traits : ItemTraits = item_pool.get_item(item_name)
	if item_traits.triggers_when_sold:
		var item_specifications : ItemSpecification = ItemDatabase.get_node(item_name)
		item_specifications.trigger(item_level, ItemSpecification.TRIGGER_CAUSES.sold_this_item)


func on_buy_other_item() -> void:
	for item_name in backpack.held_items:
		var item_traits : ItemTraits = item_pool.get_item(item_name)
		if item_traits.triggers_when_bought_other_item:
			var item_level : int = backpack.get_item_level(item_name)
			var item_specifications : ItemSpecification = ItemDatabase.get_node(item_name)
			item_specifications.trigger(item_level, ItemSpecification.TRIGGER_CAUSES.bought_other_item)


func on_sell_other_item() -> void:
	for item_name in backpack.held_items:
		var item_traits : ItemTraits = item_pool.get_item(item_name)
		if item_traits.triggers_when_sold_other_item:
			var item_level : int = backpack.get_item_level(item_name)
			var item_specifications : ItemSpecification = ItemDatabase.get_node(item_name)
			item_specifications.trigger(item_level, ItemSpecification.TRIGGER_CAUSES.sold_other_item)


# as of now this is only needed for falsegod since it overwrites hooks and max hooks to 1
func recompute_hooks_and_max_hooks() -> void:
	bobber_stats.reset_hooks_and_max_hooks()
	set_up_stats_at_start_of_fishing()
	override_stats_at_start_of_fishing()


func _on_ProximityAreaDetector_area_entered(area):
	change_num_of_proximity_areas_in_by(1)
	on_entered_proximity_area()


func _on_ProximityAreaDetector_area_exited(area):
	change_num_of_proximity_areas_in_by(-1)
