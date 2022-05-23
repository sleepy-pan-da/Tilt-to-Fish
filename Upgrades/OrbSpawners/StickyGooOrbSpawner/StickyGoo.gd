extends Area2D

onready var animation_player = $AnimationPlayer
var slow_by : float

func _ready() -> void:
	SfxManager.bobber.sticky_goo.play("Deploy")
	animation_player.play("SetUp")


func set_incremented_values(new_incremented_values) -> void:
	slow_by = new_incremented_values[0]


func _on_StickyGoo_body_entered(body):
	var state_machine : StateMachine = body.get_node_or_null("StateMachine")
	if state_machine:
		state_machine.slow_multiplier = max(state_machine.slow_multiplier - slow_by, 0.1)
		#print(state_machine.slow_multiplier)

func _on_StickyGoo_body_exited(body):
	var state_machine : StateMachine = body.get_node_or_null("StateMachine")
	if state_machine:
		state_machine.slow_multiplier = max(state_machine.slow_multiplier + slow_by, 0.1)
		#print(state_machine.slow_multiplier)
		

func _on_Timer_timeout():
	animation_player.play("Collapse")
