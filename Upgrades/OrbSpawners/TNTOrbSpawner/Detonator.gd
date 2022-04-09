extends Area2D

func _on_SetUpTimer_timeout():
	monitoring = true


func _on_Detonator_body_entered(body):
	GameEvents.emit_signal("detonated_charges")
	queue_free()
