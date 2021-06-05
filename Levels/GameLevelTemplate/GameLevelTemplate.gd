extends Node2D

#export(Resource) var fish_generator = fish_generator as FishGeneratorBasedOnFloor
onready var fishes = $Fishes
onready var bobber = $Bobber
onready var hooks_label = $UI/HooksLabel
onready var flow_progress = $UI/FlowProgress


func _ready() -> void:
	update_hooks_label()
	GameEvents.connect("bobber_took_damage", self, "_on_bobber_took_damage")


func _on_bobber_took_damage() -> void:
	freeze_game()
	update_hooks_label()
	if bobber.bobber_stats.hooks_amount <= 0:
		game_over()


func freeze_game() -> void:
	var freeze_duration : float = 0.1
	get_tree().paused = true
	yield(get_tree().create_timer(freeze_duration), 'timeout')
	get_tree().paused = false


func update_hooks_label() -> void:
	hooks_label.text = "Hooks : " + str(bobber.bobber_stats.hooks_amount)


func game_over() -> void:
	bobber.queue_free()


