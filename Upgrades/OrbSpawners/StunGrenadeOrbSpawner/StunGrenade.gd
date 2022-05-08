extends Area2D

export(PackedScene) onready var explosion
onready var animation_player = $AnimationPlayer

var stun_duration : float
var damage : float
var is_triggered : bool = false

func _ready():
	animation_player.play("SetUp")


func on_finished_set_up() -> void:
	monitoring = true


func set_incremented_values(new_incremented_values) -> void:
	stun_duration = new_incremented_values[0]
	#print("StunGrenade's stun is " + str(stun_duration) + "s")
	damage = new_incremented_values[2]
	#print("StunGrenade's damage is " + str(damage))


func _on_StunGrenade_body_entered(body):
	if !is_triggered:
		is_triggered = true
		animation_player.play("Triggered")


func explode() -> void:
	var triggered_instance = explosion.instance()
	get_parent().add_child(triggered_instance)
	triggered_instance.set_stun_duration(stun_duration)
	triggered_instance.set_damage(damage)
	triggered_instance.global_position = global_position
	queue_free()
