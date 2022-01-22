extends Node

export(Resource) var bobber_stats = bobber_stats as BobberStats

# this manages the spawn order of orbs in the form of a FIFO queue
var spawn_order = [] # array of node references

func _ready() -> void:
	GameEvents.connect("bobber_touched_orb", self, "spawn_next_orb")


func spawn_next_orb() -> void:
	var current_orb_spawner : OrbSpawner = spawn_order.pop_front()
	if !current_orb_spawner:
		return
	current_orb_spawner.spawn_orb(get_node("../Orbs"))
	spawn_order.push_back(current_orb_spawner)


func add_latest_child_to_spawn_order() -> void:
	var latest_child : OrbSpawner = get_child(get_child_count() - 1)
	spawn_order.push_back(latest_child)


func set_up() -> void:
	spawn_order.shuffle()
	# spawn the orbs from the front of spawn order 
	# and start their corresponding timers
	# how many orbs to spawn is based on bobber_stats.max_orbs
	var popped_orb_spawners = []
	for i in range(bobber_stats.max_orbs):
		var current_orb_spawner : OrbSpawner = spawn_order.pop_front()
		if !current_orb_spawner:
			break
		current_orb_spawner.spawn_orb(get_node("../Orbs"))
		popped_orb_spawners.push_back(current_orb_spawner)
	spawn_order.append_array(popped_orb_spawners)
