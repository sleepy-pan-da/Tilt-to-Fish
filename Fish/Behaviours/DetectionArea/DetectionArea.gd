extends Area2D

onready var collision_shape = $CollisionShape2D
signal detected_bobber(bobber)
signal lost_bobber


func _on_DetectionArea_body_entered(body : Bobber) -> void:
	emit_signal("detected_bobber", body)


func _on_DetectionArea_body_exited(body : Bobber) -> void:
	emit_signal("lost_bobber")


func enable_detection_area() -> void:
	collision_shape.disabled = false


func disable_detection_area() -> void:
	collision_shape.disabled = true
