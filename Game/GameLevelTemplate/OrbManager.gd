extends Node

export(Resource) var bobber_stats = bobber_stats as BobberStats

# this manages the spawn order of orbs in the form of a FIFO queue
var spawn_order = [] # array of node references


func add_latest_child_to_spawn_order() -> void:
	var latest_child : OrbSpawner = get_child(get_child_count() - 1)
	spawn_order.push_back(latest_child)


func set_up() -> void:
	spawn_order.shuffle()
	# spawn the orbs from the front of spawn order 
	# and start their corresponding timers
	# how many orbs to spawn is based on bobber_stats.max_orbs
