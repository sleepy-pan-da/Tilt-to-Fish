extends Area2D

signal bobber_touched_long_rest_orb

func _on_LongRestOrb_body_entered(body : Bobber):
	body.start_long_rest(10)
	emit_signal("bobber_touched_long_rest_orb")
	queue_free()

