extends FishManager

# how does the wave system work?
# go onto next wave if
# 1. catch all remaining fish 
# or
# 2. timer runs out (each wave has a timer of 20s?)

onready var wave_timer = $WaveTimer
export(Resource) var fish_to_spawn = fish_to_spawn as FishToSpawn
var wave_number : int = 1
signal proceeded_to_next_wave

func _on_WaveTimer_timeout() -> void:
	proceed_to_next_wave()
	

func proceed_to_next_wave() -> void:
	wave_timer.stop()
	wave_number += 1
	spawn_fish()
	emit_signal("proceeded_to_next_wave")


func spawn_fish():
	# wave 1-5 -> spawns 1 fish
	# wave 6-10 -> spawns 2 fish
	# wave 11-15 -> spawns 3 fish
	var number_of_fish_to_spawn : int = (wave_number/5) + 1
	for i in range(number_of_fish_to_spawn):
		var index: int = fish_to_spawn.generate_random_index_for_fish()
		var spawned_fish : FishTemplate = fish_to_spawn.fishes[index].instance()
		add_child(spawned_fish)
		spawned_fish.global_position = generate_random_pt_on_screen()
	wave_timer.start()
	

func generate_random_pt_on_screen() -> Vector2:
	randomize()
	var x_coordinate : int = rand_range(320, 960)
	var y_coordinate : int = rand_range(256, 512)
	var computed_pt : Vector2 = Vector2(x_coordinate, y_coordinate)
	return computed_pt
