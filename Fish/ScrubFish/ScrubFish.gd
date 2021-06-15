extends FishTemplate

class_name ScrubFish


onready var kinematic_body = $KinematicBody
onready var fixed_path_movement = $FixedPathMovement



func _ready() -> void:
	fixed_path_movement.connect("assigned_fixed_path", self, "on_assigned_fixed_path")
	fixed_path_movement.connect("moved_along_path", self, "on_moved_along_path")
	set_up_progress_bar()
	fixed_path_movement.set_up()


func on_assigned_fixed_path() -> void:
	# need to make path_to_follow the parent of kinematic body for fish to follow path
	reparent(kinematic_body, fixed_path_movement.path_to_follow)


func on_moved_along_path(direction_of_motion : Vector2) -> void:
	update_fish_sprite_based_on_horizontal_direction(direction_of_motion)
