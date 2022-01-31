extends Projectile

class_name TurretProjectile

var damage : float

func get_class() -> String:
	return "TurretProjectile"


func set_damage(new_damage) -> void:
	damage = new_damage


# overridden function
func _on_HitBox_body_entered(body : Bobber) -> void:
	if !body.immune:
		GameEvents.emit_signal("bobber_took_damage", 1)
		queue_free() # added functionality
