extends Orb


func _on_AcidOrb_body_entered(body):
	GameEvents.emit_signal("bobber_touched_orb", "Acid")
	GameEvents.emit_signal("triggered_orb_that_requires_bobber", "Acid", incremented_values)
	queue_free()


func set_incremented_values(new_incremented_values) -> void:
	incremented_values = new_incremented_values
	set_cooldown_duration(incremented_values[1])
