extends Node2D

#export(Resource) var fish_generator = fish_generator as FishGeneratorBasedOnFloor
onready var fishes = $Fishes
onready var bobber = $Bobber
onready var hooks_label = $HooksLabel


func _ready() -> void:
	update_hooks_label()
	GameEvents.connect("bobber_took_damage", self, "update_hooks_label")
	GameEvents.connect("bobber_ran_out_of_hooks", self, "game_over")


func update_hooks_label() -> void:
	hooks_label.text = "Hooks : " + str(bobber.bobber_stats.hooks_amount)


func game_over() -> void:
	bobber.queue_free()
