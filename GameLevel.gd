extends Node2D

export(Resource) var fish_generator = fish_generator as FishGeneratorBasedOnFloor
onready var fishes = $Fishes


func _ready():
	var fish = fish_generator.array_of_fish[0].instance()
	fishes.add_child(fish)
	fish.position = self.position
