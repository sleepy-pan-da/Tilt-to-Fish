extends Orb

export(PackedScene) onready var Thunder

func _on_ThunderOrb_body_entered(body):
	GameEvents.emit_signal("bobber_touched_orb", "Thunder")
	var triggered_instance = Thunder.instance()
	get_parent().get_parent().call_deferred("add_child", triggered_instance)
	triggered_instance.call_deferred("set_incremented_values", incremented_values)
	triggered_instance.set_deferred("global_position", global_position)
	queue_free()


func set_incremented_values(new_incremented_values) -> void:
	incremented_values = new_incremented_values
	set_cooldown_duration(incremented_values[1])
