extends Area2D


func _on_Rejuvenated_Orb_body_entered(body : Bobber):
	body.start_rejuvenated(5)
	queue_free()
