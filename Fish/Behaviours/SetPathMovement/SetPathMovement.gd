extends Node2D

# How to use this node?
# Attach a path scene to this node to set fish's path 

export(int) var initial_speed : int
export(int) var offset_direction : int = 1 # 1 = forward, -1 = backward

var assigned_path : Path2D
var path_to_follow : PathFollow2D
var speed : float 
var direction_of_acceleration : int = 0
var initial_position : Vector2 

func _ready():
	speed = initial_speed
	assigned_path = get_node_of_fish_path()
	if assigned_path != null:
		path_to_follow = assigned_path.get_child(0)
		# PathFollow2D needs to be parent of kinematic body for fish to follow path
		#reparent(kinematic_body, path_to_follow)
		initial_position = path_to_follow.position

func get_node_of_fish_path() -> Node:
	var child_nodes : Array = get_children()
	for i in range(child_nodes.size()):
		if child_nodes[i].get_class() == "Path2D":
			return child_nodes[i]
	return null
