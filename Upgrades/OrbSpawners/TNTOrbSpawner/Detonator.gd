extends Area2D

func _on_SetUpTimer_timeout():
	monitoring = true


func _on_Detonator_body_entered(body):
	SfxManager.bobber.tnt.play("Detonate")
	yield(get_tree().create_timer(0.2), "timeout")
	GameEvents.emit_signal("detonated_charges")
	queue_free()
