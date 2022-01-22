extends Orb


func _on_ArrowOrb_body_entered(body) -> void:
	GameEvents.emit_signal("bobber_touched_orb")
	queue_free()
