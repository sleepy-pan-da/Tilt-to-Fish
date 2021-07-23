extends Area2D

signal bobber_touched_hook

func _on_Hook_body_entered(body : Bobber):
	body.bobber_stats.gain_hook(1)
	emit_signal("bobber_touched_hook")
	GameEvents.emit_signal("bobber_gained_hook", 1)
	queue_free()
