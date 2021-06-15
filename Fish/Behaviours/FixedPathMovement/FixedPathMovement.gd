extends Node2D

# How to use this node?
# Attach a path scene to this node to set fish's path 

export(int) var speed : float
export(int) var offset_direction : int = 1 # 1 = forward, -1 = backward

var assigned_path : Path2D
var path_to_follow : PathFollow2D
var initial_position : Vector2 

signal assigned_fixed_path
signal moved_along_path(direction_of_motion)


func set_up() -> void:
	assigned_path = get_node_of_fish_path()
	if assigned_path != null:
		path_to_follow = assigned_path.get_child(0)
		# PathFollow2D needs to be parent of kinematic body for fish to follow path
		emit_signal("assigned_fixed_path")
		initial_position = path_to_follow.position


func get_node_of_fish_path() -> Node:
	var child_nodes : Array = get_children()
	for i in range(child_nodes.size()):
		if child_nodes[i].get_class() == "Path2D":
			return child_nodes[i]
	return null


func _physics_process(delta : float):
	if(path_to_follow != null):
		move(delta)


func move(delta : float):
	initial_position = path_to_follow.position
	path_to_follow.offset += speed * delta * offset_direction
	emit_signal("moved_along_path", return_direction_of_motion())


func return_direction_of_motion() -> Vector2:
	var direction : Vector2 = initial_position.direction_to(path_to_follow.position)
	return direction 
