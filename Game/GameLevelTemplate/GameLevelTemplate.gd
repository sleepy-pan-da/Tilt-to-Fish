extends Node2D

export(PackedScene) onready var next_scene 
export(PackedScene) onready var current_bobber
export(PackedScene) onready var free_money
export(PackedScene) onready var pumping_iron
export(PackedScene) onready var periodic_life_gain
export(PackedScene) onready var rejuvenated
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
onready var stats = $UI/Stats
onready var screen_transition = $UI/ScreenTransition

var bobber : Bobber
var bobber_path : NodePath
var can_descend : bool = false
var proceeding_to_next_wave : bool = false

func _ready() -> void:
	screen_transition.transition_in()
	create_bobber_instance()
	set_up_game_based_on_backpack()
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
	wave_number_progress_bar.connect("turned_black_mamba", self, "on_turned_black_mamba")
	wave_number_progress_bar.connect("ran_out_of_enthusiasm", self, "on_ran_out_of_enthusiasm")
	

			

func create_bobber_instance() -> void:
	if current_bobber != null: # helps to test without bobber
		bobber = current_bobber.instance()
		bobber.connect("bobber_entered_scene", self, "on_bobber_entered_scene")
		bobber.connect("intimidated_fish", self, "on_intimidated_fish")
		bobber.connect("retaliated_fish", self, "on_retaliated_fish")
		bobber.connect("updated_damage", self, "on_updated_damage")

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
		bobber_path = NodePath("Bobber")
		bobber.global_position = bobber_spawn_pt.global_position


func on_bobber_entered_scene() -> void:
	stats.update_labels(bobber)
		
	
func _on_bobber_took_damage(damage_taken : int) -> void:
	freeze_game()
	set_up_game_based_on_backpack_upon_taking_damage(damage_taken)
	update_hooks_label()
	bobber.start_immunity()
	if bobber.bobber_stats.hooks_amount <= 0:
		game_over()


func on_bobber_gained_hook(num_of_hook_gained : int) -> void:
	set_up_game_based_on_backpack_upon_gaining_hook(num_of_hook_gained)


func _on_successfully_caught_fish(fish_position : Vector2) -> void:
	if has_node(bobber_path):
		var backpack = bobber.backpack
		fishes.update_fishes_remaining_upon_successful_catch()
		set_up_game_based_on_backpack_upon_catching_fish(fish_position)


func on_intimidated_fish(bobber_intimidation : Node, fish_position : Vector2) -> void:
	add_child(bobber_intimidation)
	bobber_intimidation.global_position = fish_position


func on_retaliated_fish(bobber_retaliation : Node, bobber_position : Vector2) -> void:
	add_child(bobber_retaliation)
	bobber_retaliation.global_position = bobber_position


func on_updated_damage() -> void:
	stats.update_labels(bobber)
	

func proceed_to_next_wave_after_catching_all_fish() -> void:
	if wave_system_enabled:
		if has_node(bobber_path) and !proceeding_to_next_wave:
			if GameData.current_wave_number % 3 == 0: # final wave of the round
				proceeding_to_next_wave = true
				GameData.increment_round_number()
				bobber.bobber_stats.collect_interest()
				bobber.bobber_stats.increment_gold(2 + GameData.difficulty_modifier)
				bobber.queue_free()
				screen_transition.transition_out()
			else:
				proceed_to_next_wave()


func proceed_to_next_wave_after_timing_out() -> void:
	if wave_system_enabled:
		if has_node(bobber_path) and !proceeding_to_next_wave:
			if GameData.current_wave_number % 3 != 0: # not final wave of the round
				proceed_to_next_wave()
	

func proceed_to_next_wave() -> void:
	proceeding_to_next_wave = true
	yield(get_tree().create_timer(1), "timeout") # temporary solution to prevent intimidate from breaking the game
	bobber.start_immunity() # prevent getting hit unfairly when fish spawn (temp solution)
	fishes.proceed_to_next_wave()
	update_wave_number_label(GameData.current_wave_number)
	set_up_game_based_on_backpack_upon_proceeding_to_next_wave()
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




# UPGRADES!!!

# will be called in the ready function before bobber is added to scene
# used to set up boolean flags or non-damage stats like hooks
func set_up_game_based_on_backpack() -> void:
	var backpack = bobber.backpack
	var bobber_stats = bobber.bobber_stats
	if backpack.has_item("Black Mamba"):
		wave_number_progress_bar.black_mamba = true
	if backpack.has_item("Enthusiasm"):
		wave_number_progress_bar.enthusiasm = true
	if backpack.has_item("Live Fast"):
		wave_number_progress_bar.set_wave_duration(wave_number_progress_bar.wave_duration / 2)
	if backpack.has_item("Captain Hook Alpha"):
		bobber.activate_captain_hook_alpha()
		update_hooks_label()
	if backpack.has_item("Free Money"):
		set_up_free_money()
	if backpack.has_item("Pumping Iron"):
		set_up_pumping_iron()
	if backpack.has_item("Periodic Life Gain"):
		set_up_periodic_life_gain()
	if backpack.has_item("Rejuvenated"):
		set_up_rejuvenated()


func set_up_game_based_on_backpack_upon_proceeding_to_next_wave() -> void:
	var backpack = bobber.backpack
	var bobber_stats = bobber.bobber_stats
	if backpack.has_item("Black Mamba"):
		# resets black mamba
		if wave_number_progress_bar.turned_black_mamba:
			wave_number_progress_bar.turned_black_mamba = false
			bobber.deactivate_black_mamba()
	if backpack.has_item("Enthusiasm"):
		# resets enthusiasm
		if wave_number_progress_bar.turned_unenthusiastic:
			wave_number_progress_bar.turned_unenthusiastic = false
			bobber.activate_enthusiasm()	
	bobber.update_damage()
	

func set_up_game_based_on_backpack_upon_taking_damage(damage_taken : int) -> void:
	var backpack = bobber.backpack
	var bobber_stats = bobber.bobber_stats
	if backpack.has_item("Confidence"):
		bobber.update_confidence_upon_taking_damage(damage_taken)
	if backpack.has_item("Underdog"):
		if bobber.can_activate_underdog():
			bobber.activate_underdog()
	if backpack.has_item("Reassuring Confidence"):
		bobber.update_reassuring_confidence_upon_taking_damage()
	if backpack.has_item("Masochistic"):
		bobber.update_masochistic()
	if backpack.has_item("Thrill Seeker"):
		bobber.reset_thrill_seeker_upon_taking_damage()
	
	bobber.update_damage()
	
	# this needs to be after update damage with newly computed damage multiplier
	if backpack.has_item("Retaliation"):
		bobber.instantiate_retaliation()
	
		
func set_up_game_based_on_backpack_upon_gaining_hook(num_of_hook_gained : int) -> void:
	var backpack = bobber.backpack
	var bobber_stats = bobber.bobber_stats
	if backpack.has_item("Confidence"):
		bobber.update_confidence_upon_gaining_hook(num_of_hook_gained)
	bobber.update_damage()
	

func set_up_game_based_on_backpack_upon_catching_fish(fish_position : Vector2) -> void:
	var backpack = bobber.backpack
	var bobber_stats = bobber.bobber_stats
	if backpack.has_item("Reassuring Confidence"):
		bobber.update_reassuring_confidence_upon_catching_fish()
	if backpack.has_item("Get Excited"):
		bobber.get_excited()
	if backpack.has_item("Captain Hook Beta"):
		if bobber.can_activate_captain_hook_beta(fishes.num_of_fishes_caught):
			bobber.activate_captain_hook_beta()
			update_hooks_label()
	if backpack.has_item("Rejuvenated"):
		if bobber.rejuvenated:
			bobber_stats.gain_hook(1)
			update_hooks_label()
	
	bobber.update_damage()
	
	# this needs to be after update damage with newly computed damage multiplier
	if backpack.has_item("Intimidate"):
		bobber.instantiate_intimidate(fish_position)
	
	
func on_turned_black_mamba() -> void:
	var bobber_stats = bobber.bobber_stats
	bobber.activate_black_mamba()	
	bobber.update_damage()
	

func on_ran_out_of_enthusiasm() -> void:
	var bobber_stats = bobber.bobber_stats
	bobber.deactivate_enthusiasm()	
	bobber.update_damage()


func set_up_free_money() -> void:
	var backpack = bobber.backpack
	var current_free_money = free_money.instance()
	add_child(current_free_money)
	current_free_money.connect("created_coin", self, "on_created_coin")
	if backpack.item_level("Free Money") == 1:
		current_free_money.set_timer(30)
	elif backpack.item_level("Free Money") == 2:
		current_free_money.set_timer(20)
	else:
		current_free_money.set_timer(10)
	current_free_money.start_timer()


func on_created_coin(coin) -> void:
	add_child(coin)
	coin.global_position = fishes.generate_random_pt_on_screen()


func set_up_pumping_iron() -> void:
	var current_pumping_iron = pumping_iron.instance()
	add_child(current_pumping_iron)
	current_pumping_iron.connect("created_iron", self, "on_created_iron")
	current_pumping_iron.set_timer(5)
	current_pumping_iron.start_timer()


func on_created_iron(iron) -> void:
	iron.global_position = fishes.generate_random_pt_on_screen()


func set_up_periodic_life_gain() -> void:
	var backpack = bobber.backpack
	var current_periodic_life_gain = periodic_life_gain.instance()
	add_child(current_periodic_life_gain)
	current_periodic_life_gain.connect("created_hook", self, "on_created_hook")
	if backpack.item_level("Periodic Life Gain") == 1:
		current_periodic_life_gain.set_timer(20)
	elif backpack.item_level("Periodic Life Gain") == 2:
		current_periodic_life_gain.set_timer(10)
	else:
		current_periodic_life_gain.set_timer(5)
	current_periodic_life_gain.start_timer()


func on_created_hook(hook) -> void:
	add_child(hook)
	hook.global_position = fishes.generate_random_pt_on_screen()
	hook.connect("bobber_touched_hook", self, "update_hooks_label")


func set_up_rejuvenated() -> void:
	var backpack = bobber.backpack
	var current_rejuvenated = rejuvenated.instance()
	add_child(current_rejuvenated)
	current_rejuvenated.connect("created_rejuvenate_orb", self, "on_created_rejuvenate_orb")
	if backpack.item_level("Rejuvenated") == 1:
		current_rejuvenated.set_timer(40)
	elif backpack.item_levl("Rejuvenated") == 2:
		current_rejuvenated.set_timer(30)
	else:
		current_rejuvenated.set_timer(20)
	current_rejuvenated.start_timer()
	

func on_created_rejuvenate_orb(rejuvenate_orb) -> void:
	add_child(rejuvenate_orb)
	rejuvenate_orb.global_position = fishes.generate_random_pt_on_screen() 
	
