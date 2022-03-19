extends Node2D

onready var sprite = $Sprite
onready var collision_shape = $CollisionShape2D
var stun_duration : float
var damage : float

func _ready():
	collision_shape.shape.radius = 129


func _physics_process(delta):
	sprite.frame += 1
	sprite.frame += 1
	if sprite.frame == 54:
		collision_shape.shape.radius = 180
	if sprite.frame > 81:
		queue_free()


func get_name() -> String:
	return "StunGrenadeExplosion"


func set_stun_duration(new_stun_duration : float):
	stun_duration = new_stun_duration


func set_damage(new_damage : float):
	damage = new_damage
	

func _on_StunGrenadeExplosion_body_entered(body : Bobber):
	if !body.is_immune:
		GameEvents.emit_signal("bobber_took_damage", 1)
