extends Timer

export(PackedScene) var plasma_field

var damage : float 
var cooldown : float

func _on_PlasmaFieldTimer_timeout():
	pass
	# instantiate plasma field

func set_value(incremented_values) -> void:
	damage = incremented_values[0]
	cooldown = incremented_values[1]
