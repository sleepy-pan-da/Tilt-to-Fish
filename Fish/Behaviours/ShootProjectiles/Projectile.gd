extends "res://Fish/Behaviours/FishHitBox/FishHitBox.gd"

class_name Projectile

var velocity : Vector2
var slow_multiplier : float = 1.0

func _physics_process(delta):
	translate(velocity * delta * slow_multiplier)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func get_class() -> String:
	return "Projectile"

# overridden function
func _on_HitBox_body_entered(body : Bobber) -> void:
	if !body.immune:
		emit_signal("bobber_entered_hitbox")
		queue_free() # added functionality

