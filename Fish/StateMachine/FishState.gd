# Boilerplate class to get full autocompletion and type checks for the `FishTemplate` when coding the fish's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name FishState
extends State

# Typed reference to the fish node.
var fish : FishTemplate


func _ready() -> void:
	# The states are children of the `Fish` node so their `_ready()` callback will execute first.
	# That's why we wait for the `owner` to be ready first.
	yield(owner, "ready")
	# The `as` keyword casts the `owner` variable to the `FishTemplate` type.
	# If the `owner` is not a `FishTemplate`, we'll get `null`.
	fish = owner as FishTemplate
	# This check will tell us if we inadvertently assign a derived state script
	# in a scene other than scenes that inherit from `FishTemplate.tscn`, which would be unintended. This can
	# help prevent some bugs that are difficult to understand.
	assert(fish != null)
