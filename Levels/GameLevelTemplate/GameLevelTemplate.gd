extends Node2D

export(PackedScene) onready var next_scene 
export(PackedScene) onready var current_bobber
export var wave_system_enabled : bool = true # used for disabling wave system and testing individual fish

onready var fishes = $Fishes
onready var bobber_spawn_pt = $BobberSpawnPt
onready var hooks_label = $UI/Hooks/HooksLabel
onready var countdown = $UI/Countdown
onready var congrats = $UI/Congrats
onready var wave_number_label = $UI/WaveNumber/Label
onready var wave_number_progress_bar = $UI/WaveNumber/ProgressBar
onready var game_over = $UI/GameOver

var bobber : Bobber
var can_descend : bool = false


func _ready() -> void:
	create_bobber_instance()
	update_hooks_label()
	countdown.connect("countdown_finished", self, "on_countdown_finished")
	GameEvents.connect("bobber_took_damage", self, "_on_bobber_took_damage")
	GameEvents.connect("successfully_caught_fish", self, "_on_successfully_caught_fish")
	fishes.connect("caught_all_fishes", self, "on_caught_all_fishes")
	fishes.connect("proceeded_to_next_wave", self, "on_proceeded_to_next_wave")
	game_over.connect("clicked_play_again", self, "restart")


func create_bobber_instance() -> void:
	if current_bobber != null: # helps to test without bobber
		bobber = current_bobber.instance()


func update_hooks_label() -> void:
	if current_bobber != null: # helps to test without bobber
		if bobber.bobber_stats.hooks_amount > 0:
			hooks_label.text = str(0) + str(bobber.bobber_stats.hooks_amount)
		else:
			hooks_label.text = str(0)


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
	
	
func _on_bobber_took_damage() -> void:
	freeze_game()
	update_hooks_label()
	bobber.start_immunity()
	if bobber.bobber_stats.hooks_amount <= 0:
		game_over()


func _on_successfully_caught_fish() -> void:
	fishes.update_fishes_remaining_upon_successful_catch()


func on_caught_all_fishes() -> void:
	if wave_system_enabled:
		fishes.proceed_to_next_wave()
	#congratulate_player()
	#allow_player_to_descend()
	

func on_proceeded_to_next_wave() -> void:
	bobber.start_immunity() # prevent getting hit unfairly when fish spawn (temp solution)
	update_wave_number_label(fishes.wave_number)
	wave_number_progress_bar.reset_progress_bar()

	
func freeze_game() -> void:
	var freeze_duration : float = 0.2
	get_tree().paused = true
	yield(get_tree().create_timer(freeze_duration), 'timeout')
	get_tree().paused = false


func game_over() -> void:
	if wave_system_enabled:
		bobber.bobber_stats.reset()
		bobber.queue_free()
		if GameData.beat_high_score(fishes.wave_number):
			GameData.update_high_score(fishes.wave_number)
			game_over.update_high_score_label(GameData.highest_wave_number_reached)
		game_over.show()

func congratulate_player() -> void:
	congrats.show()


func allow_player_to_descend() -> void:
	can_descend = true
	

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed() and can_descend:
			transition_to_next_scene()
			

func transition_to_next_scene() -> void:
	if next_scene != null:
		get_tree().change_scene_to(next_scene)
		

func restart() -> void:
	get_tree().reload_current_scene()	
