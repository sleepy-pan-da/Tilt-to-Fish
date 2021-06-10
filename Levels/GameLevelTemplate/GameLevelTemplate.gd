extends Node2D

export(PackedScene) onready var next_scene 

onready var fishes = $Fishes
onready var bobber = $Bobber
onready var hooks_label = $UI/Hooks/HooksLabel
onready var countdown = $UI/Countdown
onready var congrats = $UI/Congrats
var can_descend : bool = true


func _ready() -> void:
	toggle_bobber(false)
	update_hooks_label()
	countdown.connect("countdown_finished", self, "on_countdown_finished")
	GameEvents.connect("bobber_took_damage", self, "_on_bobber_took_damage")
	GameEvents.connect("successfully_caught_fish", self, "_on_successfully_caught_fish")
	fishes.connect("caught_all_fishes", self, "on_caught_all_fishes")


func toggle_bobber(can_move : bool) -> void:
	bobber.enabled = can_move


func update_hooks_label() -> void:
	hooks_label.text = str(0) + str(bobber.bobber_stats.hooks_amount)


func on_countdown_finished() -> void:
	toggle_bobber(true)
	

func _on_bobber_took_damage() -> void:
	freeze_game()
	update_hooks_label()
	if bobber.bobber_stats.hooks_amount <= 0:
		game_over()


func _on_successfully_caught_fish() -> void:
	fishes.update_fishes_remaining_upon_successful_catch()


func on_caught_all_fishes() -> void:
	congratulate_player()
	allow_player_to_descend()
	

func freeze_game() -> void:
	var freeze_duration : float = 0.1
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
