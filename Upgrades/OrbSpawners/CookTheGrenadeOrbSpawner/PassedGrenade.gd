extends Node2D

export(PackedScene) onready var explosion
onready var animation_player = $AnimationPlayer

var damage : float

func on_passed(accumulated_damage : float, time_spent_cooking : float):
	damage = accumulated_damage
	animation_player.play("Cooking")
	animation_player.seek(time_spent_cooking, true)


func explode() -> void:
	var triggered_instance = explosion.instance()
	var gamelevel_template_reference = get_parent().get_parent().get_parent().get_parent()
	gamelevel_template_reference.add_child(triggered_instance) 
	triggered_instance.set_damage(damage)
	triggered_instance.global_position = global_position
	#print("accumulated_damage: " + str(triggered_instance.damage))
	queue_free()
