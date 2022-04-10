extends Node

export(Resource) var bobber_stats = bobber_stats as BobberStats

# this manages the spawn order of orbs in the form of a FIFO queue
var spawn_order = [] # array of node references

func _ready() -> void:
	GameEvents.connect("bobber_touched_orb", self, "spawn_next_orb")

# there should never be duplicated orbs in the level.
# when an orb is touched, it will be sent to the back of spawn order
func spawn_next_orb(name_of_orb_last_touched) -> void:
	name_of_orb_last_touched = name_of_orb_last_touched.replace(" ", "")
	send_orb_spawner_to_the_back_of_spawn_order(name_of_orb_last_touched)
	
	# get the orb spawner names to not spawn from
	var orbs_in_level = get_node("../Orbs").get_children()
	var orb_spawner_names_to_not_spawn_from = []
	name_of_orb_last_touched += "Orb"
	for orb in orbs_in_level:
		#print(orb.name)
		#print(name_of_orb_last_touched)
		if orb.name.find(name_of_orb_last_touched) == -1:
			if orb.name.begins_with("@"): # this is needed for instance names with "@", usually happens when u have multiple instances of the same packed scene
				orb.name = orb.name.split("@", false)[0]
			orb_spawner_names_to_not_spawn_from.append(orb.name + "Spawner")
	
	var current_orb_spawner : OrbSpawner
	while true:
		current_orb_spawner = spawn_order.pop_front()
		#print(current_orb_spawner.name)
		if current_orb_spawner.name in orb_spawner_names_to_not_spawn_from:
			spawn_order.push_back(current_orb_spawner)
			continue
		break
	
	current_orb_spawner.spawn_orb(get_node("../Orbs"))
	spawn_order.push_back(current_orb_spawner)


func send_orb_spawner_to_the_back_of_spawn_order(name_of_orb_last_touched : String) -> void:
	name_of_orb_last_touched += "OrbSpawner"
	var index_of_corresponding_orb_spawner : int =  get_orb_spawner_index_by_name(name_of_orb_last_touched)
	if index_of_corresponding_orb_spawner == -1:
		return
	var orb_spawner_to_send_to_the_back : OrbSpawner = spawn_order[index_of_corresponding_orb_spawner]
	spawn_order.remove(index_of_corresponding_orb_spawner)
	spawn_order.push_back(orb_spawner_to_send_to_the_back)


func get_orb_spawner_index_by_name(name_to_filter : String) -> int:
	for i in range(spawn_order.size()):
		if spawn_order[i].name == name_to_filter:
			return i
	return -1


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
