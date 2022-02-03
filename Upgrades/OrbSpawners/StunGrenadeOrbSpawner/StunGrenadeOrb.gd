extends Orb

export(PackedScene) onready var StunGrenade

func _on_StunGrenadeOrb_body_entered(body):
	GameEvents.emit_signal("bobber_touched_orb")
	var triggered_instance = StunGrenade.instance()
	get_parent().get_parent().add_child(triggered_instance)
	triggered_instance.set_incremented_values(incremented_values)
	triggered_instance.global_position = global_position
	queue_free()


func set_incremented_values(new_incremented_values) -> void:
	incremented_values = new_incremented_values
	set_cooldown_duration(incremented_values[1])
