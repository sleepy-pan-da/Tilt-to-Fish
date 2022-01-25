extends Orb


func _on_ArrowOrb_body_entered(body) -> void:
	GameEvents.emit_signal("bobber_touched_orb")
	GameEvents.emit_signal("triggered_orb_that_requires_bobber", "Arrow", incremented_values)
	queue_free()


func set_incremented_values(new_incremented_values) -> void:
	incremented_values = new_incremented_values
	set_cooldown_duration(incremented_values[1])
	print("cooldown duration is " + str(cooldown))
