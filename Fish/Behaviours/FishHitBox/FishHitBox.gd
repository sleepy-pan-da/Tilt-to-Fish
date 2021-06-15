extends Area2D

signal bobber_entered_hitbox


func _on_HitBox_body_entered(body : Bobber) -> void:
	if !body.immune:
		emit_signal("bobber_entered_hitbox")
