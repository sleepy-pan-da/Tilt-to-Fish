extends Node2D

export(Resource) var fish_generator = fish_generator as FishGeneratorBasedOnFloor
onready var fishes = $Fishes


func _ready() -> void:
	generate_fish()


func generate_fish() -> void: 
	for i in range(fish_generator.fish_type.size()):
		var fish_count = fish_generator.qty_of_fish_type[i]
		while fish_count > 0:
			var fish = fish_generator.fish_type[i].instance()
			fishes.add_child(fish)
			fish.position = self.position	
			fish_count -= 1
