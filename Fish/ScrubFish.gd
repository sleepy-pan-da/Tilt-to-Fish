extends Fish

export(Resource) var fish_paths = fish_paths as FishPaths
export(int) var max_velocity : int
export(float) var acceleration : float
export(float) var deceleration : float
export(int) var initial_velocity : int

onready var kinematic_body = $KinematicBody

var chosen_path : PackedScene
var path_to_follow : PathFollow2D
var velocity : float 
var direction_of_acceleration : int = 0


func _ready():
	amount_needed_to_catch = 200
	set_up_progress_bar()
	print(amount_needed_to_catch)
	# comment these out for debugging
	velocity = initial_velocity
	choose_path()
	assign_path()


func choose_path() -> void:
	randomize()
	var random_index : int = randi() % fish_paths.array_of_paths.size()
	chosen_path = fish_paths.array_of_paths[random_index]


func assign_path() -> void:
	var assigned_path = chosen_path.instance()
	add_child(assigned_path)
	path_to_follow = assigned_path.get_child(0)
	#PathFollow2D needs to be parent of kinematic body for fish to follow path
	reparent(kinematic_body, path_to_follow) 


func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)


func _physics_process(delta : float):
	if alerted:
		direction_of_acceleration = 1
	else:
		direction_of_acceleration = 0
	if(path_to_follow != null):
		move(delta)


func move(delta : float):
	applyAcceleration(delta)
	path_to_follow.offset += velocity * delta
	progress_bar.relocate(path_to_follow.position)

func applyAcceleration(delta : float):
	if direction_of_acceleration == 1:
		if velocity < max_velocity:
			velocity = min(velocity + acceleration * delta, max_velocity)
	elif direction_of_acceleration == -1:
		if velocity > -max_velocity:
			velocity = max(velocity - acceleration * delta, -max_velocity)
	elif direction_of_acceleration == 0:
		if velocity > 0:
			velocity = max(initial_velocity, velocity - deceleration * delta)
		elif velocity < 0:
			velocity = min(-initial_velocity, velocity + deceleration * delta)
		
