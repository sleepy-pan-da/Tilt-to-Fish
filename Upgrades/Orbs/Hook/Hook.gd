extends Area2D

signal bobber_touched_hook

func _on_Hook_body_entered(body : Bobber):
	body.bobber_stats.gain_hook(1)
	emit_signal("bobber_touched_hook")
	queue_free()
