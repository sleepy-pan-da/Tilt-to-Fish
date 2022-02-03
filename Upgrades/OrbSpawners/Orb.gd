extends Area2D

class_name Orb

export(Resource) var bobber_stats = bobber_stats as BobberStats

onready var cooldown = $Cooldown
onready var sprite = $Sprite

var cooldown_duration : float
var incremented_values

func _ready() -> void:
	cooldown.connect("finished_cooldown", self, "on_finished_cooldown")
	cooldown.set_duration(cooldown_duration)
	cooldown.start()
	

func on_finished_cooldown() -> void:
	enable()


func enable() -> void:
	monitoring = true
	sprite.show()


# to be overridden
func set_incremented_values(new_incremented_values) -> void:
	incremented_values = new_incremented_values


func set_cooldown_duration(new_cooldown_duration : float) -> void:
	cooldown_duration = new_cooldown_duration
	print("raw cooldown duration is " + str(cooldown_duration))
	var cooldown_reduction : float = bobber_stats.orb_cooldown_reduction
	cooldown_duration *= cooldown_reduction
	cooldown.set_duration(cooldown_duration)
	print("new cooldown duration is " + str(cooldown.max_value))
