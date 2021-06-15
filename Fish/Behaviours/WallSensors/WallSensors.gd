extends Node2D

onready var up_raycast = $UpRaycast
onready var down_raycast = $DownRaycast
onready var left_raycast = $LeftRaycast
onready var right_raycast = $RightRaycast
enum Directions {UP, DOWN, LEFT, RIGHT}
var array_of_raycasts : Array


func check_status_of_raycasts() -> Array:
	array_of_raycasts = [false, false, false, false]
	for i in range(4):
		array_of_raycasts[i] = check_if_raycast_is_colliding(i)
	return array_of_raycasts


func check_if_raycast_is_colliding(direction) -> bool:
	match direction:
		Directions.UP:
			return up_raycast.is_colliding()
		Directions.DOWN:
			return down_raycast.is_colliding()
		Directions.LEFT:
			return left_raycast.is_colliding()
		Directions.RIGHT:
			return right_raycast.is_colliding()
		_:
			return false

