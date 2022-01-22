extends Area2D

class_name Orb
export(float) var cooldown_duration
onready var cooldown = $Cooldown
onready var sprite = $Sprite

func _ready() -> void:
	cooldown.connect("finished_cooldown", self, "on_finished_cooldown")
	cooldown.set_duration(cooldown_duration)
	cooldown.start()
	

func on_finished_cooldown() -> void:
	enable()


func enable() -> void:
	monitoring = true
	sprite.show()


