extends Orb

export(PackedScene) onready var Detonator

func _on_TNTOrb_body_entered(body):
	GameEvents.emit_signal("bobber_touched_orb", "TNT")
	GameEvents.emit_signal("triggered_orb_that_requires_bobber", "TNT", incremented_values)
	var triggered_instance = Detonator.instance()
	get_parent().get_parent().call_deferred("add_child", triggered_instance)
	triggered_instance.set_deferred("global_position", global_position)
	queue_free()


func set_incremented_values(new_incremented_values) -> void:
	incremented_values = new_incremented_values
	set_cooldown_duration(incremented_values[1])
