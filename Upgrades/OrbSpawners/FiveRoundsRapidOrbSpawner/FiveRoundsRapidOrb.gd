extends Orb

export(PackedScene) onready var FiveRoundsRapid

func _on_FiveRoundsRapidOrb_body_entered(body):
	GameEvents.emit_signal("bobber_touched_orb")
	var triggered_instance = FiveRoundsRapid.instance()
	# adding turret to level, this scene can no longer run by itself but i think this is a
	# better solution then emiting a signal back to GameLevelTemplate
	get_parent().get_parent().add_child(triggered_instance)
	triggered_instance.set_incremented_values(incremented_values)
	triggered_instance.global_position = global_position
	#GameEvents.emit_signal("triggered_orb_that_requires_bobber", "FiveRoundsRapid", incremented_values)
	queue_free()


func set_incremented_values(new_incremented_values) -> void:
	incremented_values = new_incremented_values
	set_cooldown_duration(incremented_values[1])
	


