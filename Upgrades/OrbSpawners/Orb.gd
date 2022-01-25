extends Area2D

class_name Orb
var cooldown_duration : float
onready var cooldown = $Cooldown
onready var sprite = $Sprite
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
	cooldown.set_duration(cooldown_duration)
