extends Area2D

onready var timer = $Timer

var stop_time_duration : float
#func _ready() -> void:
#	SfxManager.bobber.sticky_goo.play("Deploy")
#	animation_player.play("SetUp")


func set_incremented_values(new_incremented_values) -> void:
	stop_time_duration = new_incremented_values[0]
	timer.wait_time = stop_time_duration
	print("time is now stopped for: " + str(timer.wait_time))
	SfxManager.bobber.time_lord_victorious.play("Stop time")
	timer.start()
	

func top_up_duration(new_incremented_values) -> void:
	var duration_to_top_up : float = new_incremented_values[0]
	timer.wait_time = timer.time_left + duration_to_top_up
	print("time is now stopped for: " + str(timer.wait_time))
	timer.start()


func _on_TimeLordVictorious_body_entered(body):
	var state_machine : StateMachine = body.get_node_or_null("StateMachine")
	if state_machine:
		state_machine.time_is_not_stopped = false
		#print(state_machine.slow_multiplier)


func _on_TimeLordVictorious_body_exited(body):
	var state_machine : StateMachine = body.get_node_or_null("StateMachine")
	if state_machine:
		state_machine.time_is_not_stopped = true
		#print(state_machine.slow_multiplier)


func _on_Timer_timeout():
	SfxManager.bobber.time_lord_victorious.play("Resume time")
	queue_free()
