extends Node2D

# damages fish upon contact
class_name OrbitingOrbsGamma

export(float) var angular_velocity
var orb_damage : float

func _process(delta) -> void:
	rotate(-angular_velocity * delta)


func compute_orb_damage(damage_multiplier : float, raw_orb_damage : float) -> void:
	orb_damage = raw_orb_damage
	orb_damage *= damage_multiplier


# need to compute_orb_damage first before doing this
func set_orb_damage() -> void:
	var orbs = get_children()
	for current_orb in orbs:
		current_orb.damage = orb_damage


func get_orb_damage() -> float:
	return orb_damage


func set_angular_velocity(new_angular_velocity : float) -> void:
	angular_velocity = new_angular_velocity
