extends Timer

export(PackedScene) var plasma_field

var damage : float 
var cooldown : float

func _ready() -> void:
	wait_time = cooldown

	
func _on_PlasmaFieldTimer_timeout() -> void:
	var triggered_instance = plasma_field.instance()
	triggered_instance.set_value(damage)
	get_parent().get_parent().add_child(triggered_instance)


func set_value(incremented_values) -> void:
	damage = incremented_values[0]
	cooldown = incremented_values[1]
