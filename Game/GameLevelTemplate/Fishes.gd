extends Node2D

class_name FishManager
# This manages the no. of remaining fish and the spawning of fish in level.

# how does the wave system work?
# go onto next wave if
# 1. catch all remaining fish 
# or
# 2. timer runs out (each wave has a timer of 30s)

export(Resource) var fish_to_spawn = fish_to_spawn as FishToSpawn

var fishes_remaining : int 
var num_of_fishes_caught : int = 0 # for items that trigger for every x fish caught

signal caught_all_fishes


func update_fishes_remaining_upon_successful_catch() -> void:
	num_of_fishes_caught += 1
	yield(get_tree(), "idle_frame") # queue free only happens at end of frame, need wait for one frame
	update_fishes_remaining()
	if fishes_remaining <= 0: 
		emit_signal("caught_all_fishes")
	

func update_fishes_remaining() -> void:
	fishes_remaining = get_child_count()


# will be called if 
# all fishes are caught
# or
# wave number timeout
func proceed_to_next_wave() -> void: 
	GameData.increment_wave_number()
	spawn_fish()


func spawn_fish():
	var number_of_fish_to_spawn : int
	# round 1 -> spawn 1 fish per wave
	# round 2 -> spawn 2 fish per wave
	# round 5 -> spawn 5 fish per wave
	if GameData.round_number <= 5:
		number_of_fish_to_spawn = GameData.round_number % 5
		if number_of_fish_to_spawn == 0:
			number_of_fish_to_spawn = 5
	else:
		# from round 6 to 8 onwards, 
		# spawn 5 to 8 fish per wave
		number_of_fish_to_spawn = (GameData.round_number % 3) + 5
	
	for i in range(number_of_fish_to_spawn):
		add_fish_to_scene()


func add_fish_to_scene() -> void:
	var index: int = fish_to_spawn.generate_random_index_for_fish()
	var spawned_fish = fish_to_spawn.fishes[index].instance()
	spawned_fish.make_fish_tankier_with_difficulty_modifier(GameData.difficulty_modifier)
	add_child(spawned_fish)
	spawned_fish.global_position = generate_random_pt_on_screen()


func generate_random_pt_on_screen() -> Vector2:
	# width = 1280
	# height = 720
	
	randomize()
	#var x_coordinate : int = rand_range(320, 960)
	#var y_coordinate : int = rand_range(256, 512)
	var x_coordinate : int
	var y_coordinate : int
	
	x_coordinate = rand_range(100, 1180)
	if x_coordinate >= 320 and x_coordinate <= 960:
		y_coordinate = rand_range(100, 620)
	else:
		y_coordinate = rand_range(256, 512)
	 
	var computed_pt : Vector2 = Vector2(x_coordinate, y_coordinate)
	return computed_pt
