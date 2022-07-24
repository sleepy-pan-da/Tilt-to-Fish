# Generic state machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
class_name StateMachine
extends Node

# Emitted when transitioning to a new state.
signal transitioned(state_name)

# Path to the initial active state. We export it to be able to pick the initial state in the inspector.
export var initial_state := NodePath()
export var nodepath_of_state_after_recover := NodePath()

# The current active state. At the start of the game, we get the `initial_state`.
onready var state: State = get_node(initial_state)
onready var state_after_recover : State = get_node(nodepath_of_state_after_recover)

var slow_multiplier : float = 1.0 # to be used to affect delta, the lower the number, the slower it gets
var time_is_not_stopped : bool = true

func _ready() -> void:
	yield(owner, "ready")
	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		child.state_machine = self
	state.enter()


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	# if time is stopped, the input below will be 0 regardless of slow_multiplier
	state.update(delta * slow_multiplier * float(time_is_not_stopped))


func _physics_process(delta: float) -> void:
	state.physics_update(delta * slow_multiplier * float(time_is_not_stopped))


# This function calls the current state's exit() function, then changes the active state,
# and calls its enter function.
# It optionally takes a `msg` dictionary to pass to the next state's enter() function.
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		return

	state.exit()
	state = get_node(target_state_name)
	#print("current state: " + state.name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
	
