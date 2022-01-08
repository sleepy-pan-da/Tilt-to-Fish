extends Node2D

export(PackedScene) onready var next_scene 
export(PackedScene) onready var current_bobber
export(PackedScene) onready var free_money
export(PackedScene) onready var pumping_iron
export(PackedScene) onready var periodic_life_gain
export(PackedScene) onready var rejuvenated
export(PackedScene) onready var long_rest
export var wave_system_enabled : bool = true # used for disabling wave system and testing individual fish

onready var fishes = $Fishes
onready var bobber_spawn_pt = $BobberSpawnPt
onready var hooks_label = $UI/Hooks/HooksLabel
onready var countdown = $UI/Countdown
onready var congrats = $UI/Congrats
onready var wave_number_label = $UI/WaveNumber/CurrentWave
onready var total_waves = $UI/WaveNumber/TotalWaves
onready var wave_number_progress_bar = $UI/WaveNumber/ProgressBar
onready var game_over = $UI/GameOver
onready var screen_transition = $UI/ScreenTransition

var bobber : Bobber
var can_descend : bool = false
var proceeding_to_next_wave : bool = false

func _ready() -> void:
	screen_transition.transition_in()
	create_bobber_instance()
	update_hooks_label()
	update_total_waves()
	GameData.reset_wave_number()
	countdown.connect("countdown_finished", self, "on_countdown_finished")
	GameEvents.connect("bobber_took_damage", self, "_on_bobber_took_damage")
	GameEvents.connect("bobber_gained_hook", self, "on_bobber_gained_hook")
	GameEvents.connect("successfully_caught_fish", self, "_on_successfully_caught_fish")
	game_over.connect("clicked_play_again", self, "on_clicked_play_again")
	screen_transition.connect("transitioned_out", self, "go_to_next_scene")
	fishes.connect("caught_all_fishes", self, "proceed_to_next_wave_after_catching_all_fish")
	wave_number_progress_bar.connect("wave_timed_out", self, "proceed_to_next_wave_after_timing_out")
	

func create_bobber_instance() -> void:
	if current_bobber != null: # helps to test without bobber
		bobber = current_bobber.instance()
		bobber.connect("bobber_entered_scene", self, "on_bobber_entered_scene")


func update_hooks_label() -> void:
	if current_bobber != null: # helps to test without bobber
		if bobber.bobber_stats.hooks_amount > 0:
			if bobber.bobber_stats.hooks_amount < 10: # 1 digit
				hooks_label.text = str(0) + str(bobber.bobber_stats.hooks_amount)
			else: # 2 digits, no need 0 at the front
				hooks_label.text = str(bobber.bobber_stats.hooks_amount)
		else:
			hooks_label.text = str(0)


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
	pass
		
	
func _on_bobber_took_damage(damage_taken : int) -> void:
	freeze_game()
	Input.vibrate_handheld(100) # to give haptic feedback to player
	update_hooks_label()
	bobber.start_immunity()
	if bobber.bobber_stats.hooks_amount <= 0:
		game_over()


func on_bobber_gained_hook(num_of_hook_gained : int) -> void:
	update_hooks_label()


func _on_successfully_caught_fish(fish_position : Vector2) -> void:
	if is_instance_valid(bobber):	
		var backpack = bobber.backpack
		fishes.update_fishes_remaining_upon_successful_catch()
	

func proceed_to_next_wave_after_catching_all_fish() -> void:
	if wave_system_enabled:
		if is_instance_valid(bobber) and !proceeding_to_next_wave:
			if GameData.current_wave_number % 3 == 0: # final wave of the round
				proceeding_to_next_wave = true
				GameData.increment_round_number()
				bobber.bobber_stats.change_gold(2 + GameData.difficulty_modifier)
				bobber.queue_free()
				screen_transition.transition_out()
			else:
				proceed_to_next_wave()

#  bobber.is_inside_tree() and 
func proceed_to_next_wave_after_timing_out() -> void:
	if wave_system_enabled and is_instance_valid(bobber): 
		if !proceeding_to_next_wave:
			if GameData.current_wave_number % 3 != 0: # not final wave of the round
				proceed_to_next_wave()
	

func proceed_to_next_wave() -> void:
	proceeding_to_next_wave = true
	yield(get_tree().create_timer(1), "timeout") # temporary solution to prevent intimidate from breaking the game
	bobber.start_immunity() # prevent getting hit unfairly when fish spawn (temp solution)
	fishes.proceed_to_next_wave()
	update_wave_number_label(GameData.current_wave_number)
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
		if GameData.beat_high_score():
			GameData.update_high_score()
			game_over.update_high_score_label(GameData.highest_round_reached)
		game_over.show()
		wave_number_progress_bar.stop_progress_bar_timer()


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


func restart() -> void:
	GameData.reset_game_upon_new_run()
	get_tree().reload_current_scene()	
