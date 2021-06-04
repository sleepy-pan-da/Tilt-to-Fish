extends Fish
class_name MovingFish

export(int) var max_speed : int
export(float) var acceleration : float
export(float) var deceleration : float
export(int) var initial_speed : int

onready var kinematic_body = $KinematicBody
onready var fish_sprite = $KinematicBody/FishSprite

var assigned_path : Path2D
var path_to_follow : PathFollow2D
var speed : float 
var direction_of_acceleration : int = 0
var initial_position : Vector2 


func _ready():
	set_up_progress_bar()
	# comment these out for debugging
	speed = initial_speed
	assigned_path = get_node_of_fish_path()
	if assigned_path != null:
		path_to_follow = assigned_path.get_child(0)
		#PathFollow2D needs to be parent of kinematic body for fish to follow path
		reparent(kinematic_body, path_to_follow)
		initial_position = path_to_follow.position
		


func get_node_of_fish_path() -> Node:
	var child_nodes : Array = get_children()
	for i in range(child_nodes.size()):
		if child_nodes[i].get_class() == "Path2D":
			return child_nodes[i]
	return null


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
	path_to_follow.offset += speed * delta
	update_fish_sprite_based_on_horizontal_direction()
	initial_position = path_to_follow.position

	
func applyAcceleration(delta : float):
	if direction_of_acceleration == 1:
		if speed < max_speed:
			speed = min(speed + acceleration * delta, max_speed)
	elif direction_of_acceleration == -1:
		if speed > -max_speed:
			speed = max(speed - acceleration * delta, -max_speed)
	elif direction_of_acceleration == 0:
		if speed > 0:
			speed = max(initial_speed, speed - deceleration * delta)
		elif speed < 0:
			speed = min(-initial_speed, speed + deceleration * delta)
		

func update_fish_sprite_based_on_horizontal_direction() -> void:
	var direction : Vector2 = initial_position.direction_to(path_to_follow.position)
	if direction.x > 0.1 and fish_sprite.animation == "FacingLeft":
		fish_sprite.animation = "FacingRight"
	elif direction.x < -0.1 and fish_sprite.animation == "FacingRight":
		fish_sprite.animation = "FacingLeft"
