extends FishTemplate


onready var hitbox = $KinematicBody/HitBox


export(int) var damage


func _ready() -> void:
	hitbox.connect("bobber_entered_hitbox", self, "on_bobber_entered_hitbox")
	set_up_progress_bar()


func on_bobber_entered_hitbox() -> void:
	bobber_in_proximity_area.bobber_stats.minus_hook(damage)
	GameEvents.emit_signal("bobber_took_damage", damage)
