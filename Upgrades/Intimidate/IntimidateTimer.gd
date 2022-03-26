extends Timer

export(PackedScene) var intimidate

var stun_duration : float 
var cooldown : float

func _ready() -> void:
	wait_time = cooldown


func _on_IntimidateTimer_timeout():
	var triggered_instance = intimidate.instance()
	triggered_instance.set_value(stun_duration)
	get_parent().get_parent().add_child(triggered_instance)


func set_value(incremented_values) -> void:
	stun_duration = incremented_values[0]
	cooldown = incremented_values[1]



