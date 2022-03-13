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

var have_immunity : bool = true 
var immune : bool = false 
var is_moving : bool = false

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
	GameEvents.connect("triggered_orb_that_requires_bobber", self, "on_triggered_orb_that_requires_bobber")
	set_up_items_at_start_of_fishing()


func on_set_up_bobber_item_at_start_of_fishing(item_name : String, incremented_values) -> void:
	var triggered_item = items_that_require_bobber.get_reference(item_name)
	var triggered_instance = triggered_item.instance()
	add_child(triggered_instance)
	triggered_instance.set_value(incremented_values)
	
	if item_name == "BulletTime":
		pass


func on_triggered_orb_that_requires_bobber(item_name : String, incremented_values) -> void:
	var triggered_item = items_that_require_bobber.get(item_name)
	var triggered_instance = triggered_item.instance()
	add_child(triggered_instance)
	triggered_instance.set_incremented_values(incremented_values)
	triggered_instance.set_bobber_reference(self)
	
	
func _physics_process(delta : float) -> void:
	if !testing_on_pc:
		move(Input.get_accelerometer())
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


func move(accelerometer_vector : Vector3) -> void:
	var speed_multiplier : int
	var x_velocity : float
	var y_velocity : float
	var velocity : Vector2
	
	if control_config.holding_preference == "regular":
		accelerometer_vector = recalibrate_regular_movement_direction_vector(accelerometer_vector)
	
	speed_multiplier = compute_speed_multiplier()	
	
	velocity =  Vector2(accelerometer_vector.x, accelerometer_vector.y)
	
	#is_moving = velocity.length() > 0.5
	if velocity.length() > 0.5:
		velocity.x = velocity.x * speed_multiplier
		velocity.y = -velocity.y * speed_multiplier 
		is_moving = true
	else:
		velocity.x = velocity.x * speed_multiplier / 2
		velocity.y = -velocity.y * speed_multiplier / 2
		is_moving = false
	
	arrow.configure_arrow_location(velocity)
	move_and_slide(velocity)


func compute_speed_multiplier() -> int:
	return 2 * control_config.tilt_sensitivity


func recalibrate_regular_movement_direction_vector(accelerometer_vector : Vector3) -> Vector3:
	var y_axis_offset : int = -7
	accelerometer_vector.y -= y_axis_offset # recalibrating movement direction vector, only y axis is changed
	accelerometer_vector.y *= 1.5 # make it easier to move downwards
	accelerometer_vector.x *= 1.5
	return accelerometer_vector


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


# as of now this is only needed for falsegod since it overwrites hooks and max hooks to 1
func recompute_hooks_and_max_hooks() -> void:
	bobber_stats.reset_hooks_and_max_hooks()
	set_up_stats_at_start_of_fishing()
	override_stats_at_start_of_fishing()
