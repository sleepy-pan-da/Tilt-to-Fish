extends Node2D

onready var sprite = $Sprite
var stun_duration : float

func _physics_process(delta):
	sprite.frame += 1
	sprite.frame += 1
	if sprite.frame > 81:
		queue_free()


func get_name() -> String:
	return "StunGrenadeExplosion"


func set_stun_duration(new_stun_duration : float):
	stun_duration = new_stun_duration


func _on_StunGrenadeExplosion_body_entered(body : Bobber):
	if !body.immune:
		GameEvents.emit_signal("bobber_took_damage", 1)
