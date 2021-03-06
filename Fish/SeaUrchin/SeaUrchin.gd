extends FishTemplate


onready var hitbox = $KinematicBody/HitBox


export(int) var damage


func _ready() -> void:
	hitbox.connect("bobber_entered_hitbox", self, "on_bobber_entered_hitbox")


func on_bobber_entered_hitbox() -> void:
	GameEvents.emit_signal("bobber_took_damage", damage)
