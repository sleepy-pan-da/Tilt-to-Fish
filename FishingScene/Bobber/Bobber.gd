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

var have_immunity : bool = true 
var immune : bool = false 

signal bobber_entered_scene


func call_when_instantiated() -> void:
	# bobber set up 
	bobber_stats.set_up_initial_stats()
	set_up_stats_at_start_of_fishing()


func _ready():
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
	backpack.held_items.clear()
	

func get_class() -> String:
	return "Bobber"


func set_up_stats_at_start_of_fishing() -> void:
	# Iterate through backpack dictionary to check for any items that require
	# setting up of stats at start of fishing
	for item_name in backpack.held_items:
		var item_traits : ItemTraits = item_pool.get_item(item_name)
		if item_traits.modifies_stats_at_start_of_fishing:
			var item_level : int = backpack.item_level(item_name)
			var item_specifications : ItemSpecification = ItemDatabase.get_node(item_name)
			item_specifications.trigger(item_level, ItemSpecification.TRIGGER_CAUSES.set_up_stats_at_start_of_fishing)

	if bobber_stats.hooks_amount > bobber_stats.max_hooks_amount:
		bobber_stats.reconfigure_hook()
