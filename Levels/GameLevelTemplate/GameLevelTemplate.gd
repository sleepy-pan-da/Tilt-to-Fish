extends Node2D

export(PackedScene) onready var next_scene 
export(PackedScene) onready var current_bobber
onready var fishes = $Fishes
onready var bobber_spawn_pt = $BobberSpawnPt
onready var hooks_label = $UI/Hooks/HooksLabel
onready var countdown = $UI/Countdown
onready var congrats = $UI/Congrats

var bobber : Bobber
var can_descend : bool = true


func _ready() -> void:
	create_bobber_instance()
	update_hooks_label()
	countdown.connect("countdown_finished", self, "on_countdown_finished")
	GameEvents.connect("bobber_took_damage", self, "_on_bobber_took_damage")
	GameEvents.connect("successfully_caught_fish", self, "_on_successfully_caught_fish")
	fishes.connect("caught_all_fishes", self, "on_caught_all_fishes")


func create_bobber_instance() -> void:
	if current_bobber != null: # helps to test without bobber
		bobber = current_bobber.instance()


func update_hooks_label() -> void:
	if current_bobber != null: # helps to test without bobber
		if bobber.bobber_stats.hooks_amount > 0:
			hooks_label.text = str(0) + str(bobber.bobber_stats.hooks_amount)
		else:
			hooks_label.text = str(0)


func on_countdown_finished() -> void:
	add_bobber_instance_to_scene()


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
	congratulate_player()
	allow_player_to_descend()
	

func freeze_game() -> void:
	var freeze_duration : float = 0.075
	get_tree().paused = true
	yield(get_tree().create_timer(freeze_duration), 'timeout')
	get_tree().paused = false


func game_over() -> void:
	bobber.queue_free()


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
