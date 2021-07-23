extends Area2D

signal bobber_touched_iron


func _on_Iron_body_entered(body : Bobber):
	body.update_pumping_iron()
	emit_signal("bobber_touched_iron")
	queue_free()
