extends Node2D

export(PackedScene) onready var next_scene 
export(PackedScene) onready var current_bobber
export(PackedScene) onready var main_menu
export var wave_system_enabled : bool = true # used for disabling wave system and testing individual fish

onready var fishes = $Fishes
onready var bobber_spawn_pt = $BobberSpawnPt
onready var hooks_label = $CanvasLayer/UI/Hooks/HooksLabel
onready var countdown = $CanvasLayer/UI/Countdown
onready var congrats = $CanvasLayer/UI/Congrats
onready var wave_number_label = $CanvasLayer/UI/WaveNumber/CurrentWave
onready var total_waves = $CanvasLayer/UI/WaveNumber/TotalWaves
onready var wave_number_progress_bar = $CanvasLayer/UI/WaveNumber/ProgressBar
onready var game_over = $CanvasLayer/UI/GameOver
onready var screen_transition = $CanvasLayer/UI/ScreenTransition
onready var debug_ui = $CanvasLayer/UI/DebugUI
onready var items_that_require_level = $ItemsThatRequireLevel
onready var orb_manager = $OrbManager
onready var pause_manager = $PauseManager

var bobber : Bobber
var can_descend : bool = false
var proceeding_to_next_wave : bool = false
var died_before : bool = false

func _ready() -> void:
	screen_transition.transition_in()
	create_bobber_instance()
	update_hooks_label()
	update_total_waves()
	RunManager.reset_wave_number()
	countdown.connect("countdown_finished", self, "on_countdown_finished")
	GameEvents.connect("bobber_took_damage", self, "_on_bobber_took_damage")
	GameEvents.connect("bobber_gained_hook", self, "on_bobber_gained_hook")
	GameEvents.connect("successfully_caught_fish", self, "_on_successfully_caught_fish")
	GameEvents.connect("triggered_item_on_caught_fish", self, "on_triggered_item_on_caught_fish")
	GameEvents.connect("set_up_orb_spawner_at_start_of_fishing", self, "on_set_up_orb_spawner_at_start_of_fishing")
	GameEvents.connect("to_restart_game_from_paused_screen", self, "restart_from_paused_screen")
	GameEvents.connect("to_quit_game_from_paused_screen", self, "quit_from_paused_screen")
	game_over.connect("clicked_play_again", self, "on_clicked_play_again")
	screen_transition.connect("transitioned_out", self, "go_to_next_scene")
	fishes.connect("caught_all_fishes", self, "proceed_to_next_wave_after_catching_all_fish")
	wave_number_progress_bar.connect("wave_timed_out", self, "proceed_to_next_wave_after_timing_out")


func create_bobber_instance() -> void:
	if current_bobber != null: # helps to test without bobber
		bobber = current_bobber.instance()
		bobber.call_when_instantiated()
		bobber.connect("bobber_entered_scene", self, "on_bobber_entered_scene")


func update_hooks_label() -> void:
	if current_bobber != null: # helps to test without bobber
		if bobber.bobber_stats.hooks_amount > 0:
			hooks_label.text = str(bobber.bobber_stats.hooks_amount) + "/" + \
			str(bobber.bobber_stats.max_hooks_amount)
		else:
			hooks_label.text = str(0) + "/" + str(bobber.bobber_stats.max_hooks_amount)


func update_total_waves() -> void:
	total_waves.text = "/" + str(3)


func update_wave_number_label(current_wave_number : int) -> void:
	wave_number_label.text = "wave " + str(current_wave_number)


func on_countdown_finished() -> void:
	add_bobber_instance_to_scene()
	if wave_system_enabled:
		fishes.spawn_fish()
		wave_number_progress_bar.start_progress_bar_timer()
	

func add_bobber_instance_to_scene() -> void:
	if bobber != null: # helps to test without bobber
		add_child(bobber)
		bobber.global_position = bobber_spawn_pt.global_position


func on_bobber_entered_scene() -> void:
	debug_ui.populate_content(bobber.bobber_stats)
	bobber.set_up_orb_spawners_at_start_of_fishing()
	orb_manager.set_up()
	
	
func _on_bobber_took_damage(damage_taken : int) -> void:
	freeze_game()
	SfxManager.bobber.play("Took damage")
	Input.vibrate_handheld(100) # to give haptic feedback to player
	var hooks_lost : int = damage_taken * bobber.bobber_stats.damage_taken_multiplier
	bobber.bobber_stats.minus_hook(damage_taken * bobber.bobber_stats.damage_taken_multiplier)
	if hooks_lost > 0:
		bobber.on_lost_hook()
		bobber.start_immunity()
	update_hooks_label()
	if bobber.bobber_stats.hooks_amount <= 0:
		if !died_before:
			died_before = true
			bobber.on_lost_all_hooks()
	# This 2nd check looks weird, but it's needed to check if u rly game over
	if bobber.bobber_stats.hooks_amount <= 0:
		game_over()


func on_bobber_gained_hook(num_of_hook_gained : int) -> void:
	update_hooks_label()


var previous_caught_fish_position : Vector2
func _on_successfully_caught_fish(fish_position : Vector2, fish_name : String) -> void:
	SfxManager.fish.play("Caught fish")
	ProphecyManager.updates_prophecies_when_caught_fish()
	if is_instance_valid(bobber):	
		var backpack = bobber.backpack
		fishes.update_fishes_remaining_upon_successful_catch()
		previous_caught_fish_position = fish_position
		bobber.on_caught_fish()
		

func on_triggered_item_on_caught_fish(item_name : String, incremented_values) -> void:	
	var triggered_item = items_that_require_level.get_reference(item_name)
	var triggered_instance = triggered_item.instance()
	call_deferred("add_child", triggered_instance)
	triggered_instance.call_deferred("set_value", incremented_values)
	
	# Have to hardcode the item names here due to the sheer difference in item behaviour
	# This allows for flexibility in the future
	if item_name == "Cccombo":
		triggered_instance.global_position = previous_caught_fish_position
		# create some ui to show combo streak


func on_set_up_orb_spawner_at_start_of_fishing(item_name : String, incremented_values) -> void:
	var triggered_item = items_that_require_level.get_reference(item_name)
	var triggered_instance : OrbSpawner = triggered_item.instance()
	triggered_instance.set_incremented_values(incremented_values)
	orb_manager.add_child(triggered_instance)
	orb_manager.add_latest_child_to_spawn_order()


func proceed_to_next_wave_after_catching_all_fish() -> void:
	if wave_system_enabled:
		if is_instance_valid(bobber) and !proceeding_to_next_wave:
			if RunManager.current_wave_number % 3 == 0: # final wave of the round
				proceeding_to_next_wave = true
				
				var earned_gold_for_the_round : int
				earned_gold_for_the_round = 1
				
#				if RunManager.round_number <= 3:
#					earned_gold_for_the_round = 1
#				elif RunManager.round_number <= 6:
#					earned_gold_for_the_round = 2
#				else:
#					earned_gold_for_the_round = 3
				bobber.bobber_stats.change_gold(earned_gold_for_the_round)
				
				bobber.queue_free()
				if Engine.time_scale != 1.0: # For Time Lord Victorious
					Engine.time_scale = 1.0
				screen_transition.transition_out()
			else:
				proceed_to_next_wave()

#  bobber.is_inside_tree() and 
func proceed_to_next_wave_after_timing_out() -> void:
	if wave_system_enabled and is_instance_valid(bobber): 
		if !proceeding_to_next_wave:
			if RunManager.current_wave_number % 3 != 0: # not final wave of the round
				proceed_to_next_wave()
	

func proceed_to_next_wave() -> void:
	proceeding_to_next_wave = true
	yield(get_tree().create_timer(1), "timeout") # temporary solution to prevent intimidate from breaking the game
	bobber.start_immunity() # prevent getting hit unfairly when fish spawn (temp solution)
	fishes.proceed_to_next_wave()
	update_wave_number_label(RunManager.current_wave_number)
	wave_number_progress_bar.reset_progress_bar()
	proceeding_to_next_wave = false

	
func freeze_game() -> void:
	var freeze_duration : float = 0.2
	get_tree().paused = true
	yield(get_tree().create_timer(freeze_duration), 'timeout')
	get_tree().paused = false


func game_over() -> void:
	if wave_system_enabled:
		bobber.reset_upon_new_run()
		bobber.queue_free()
		game_over.update_round_reached_label(RunManager.round_number)
		if RunManager.beat_high_score():
			RunManager.update_high_score()
			game_over.update_high_score_label(RunManager.player_statistics.highest_round_reached)
		game_over.show()
		wave_number_progress_bar.stop_progress_bar_timer()
		pause_manager.disable_pause()
		GameSaver.save_data()


func congratulate_player() -> void:
	congrats.show()


func allow_player_to_descend() -> void:
	can_descend = true


func go_to_next_scene() -> void:
	if game_over.visible:
		restart()
	else:
		go_to_shop()


func go_to_shop() -> void:
	if next_scene != null:
		get_tree().change_scene_to(next_scene)


func on_clicked_play_again() -> void:
	screen_transition.transition_out()		
	pause_manager.disable_pause()


func reset_game_state() -> void:
	RunManager.reset_game_upon_new_run()
	SongManager.on_restart()

func restart() -> void:
	reset_game_state()
	get_tree().reload_current_scene()	
	RunManager.on_new_run()


func restart_from_paused_screen() -> void:
	bobber.reset_upon_new_run()
	bobber.queue_free()
	pause_manager.resume_game()
	restart()


func quit_from_paused_screen() -> void:
	bobber.reset_upon_new_run()
	bobber.queue_free()
	pause_manager.resume_game()
	reset_game_state()
	get_tree().change_scene_to(main_menu)
