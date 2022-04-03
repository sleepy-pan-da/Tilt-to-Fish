extends Node2D

export(float) var angular_velocity
var orb_damage : float

func set_value(new_damage) -> void:
	orb_damage = new_damage
	set_orb_damage()


# need to compute_orb_damage first before doing this
func set_orb_damage() -> void:
	var orbs = get_children()
	for current_orb in orbs:
		current_orb.damage = orb_damage


func _process(delta) -> void:
	rotate(angular_velocity * delta)
