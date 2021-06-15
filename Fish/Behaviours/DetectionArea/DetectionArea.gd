extends Area2D

signal detected_bobber(bobber)
signal lost_bobber


func _on_DetectionArea_body_entered(body : Bobber) -> void:
	emit_signal("detected_bobber", body)


func _on_DetectionArea_body_exited(body : Bobber) -> void:
	emit_signal("lost_bobber")
