extends Orb

export(PackedScene) onready var TimeLordVictorious


func _on_TimeLordVictoriousOrb_body_entered(body):
	GameEvents.emit_signal("bobber_touched_orb", "Time Lord Victorious")
	
	# check for existing time lord victorious effect
	var level = get_parent().get_parent()
	if level:
		var child_nodes = level.get_children()
		for i in range(len(child_nodes) - 1, -1, -1):
			if "TimeLordVictorious" in child_nodes[i].name:
				# top up duration
				child_nodes[i].top_up_duration(incremented_values)
				queue_free()
				return
	
	var triggered_instance = TimeLordVictorious.instance()
	get_parent().get_parent().call_deferred("add_child", triggered_instance)
	triggered_instance.call_deferred("set_incremented_values", incremented_values)
	triggered_instance.set_deferred("global_position", global_position)
	queue_free()


func set_incremented_values(new_incremented_values) -> void:
	incremented_values = new_incremented_values
	set_cooldown_duration(incremented_values[1])



