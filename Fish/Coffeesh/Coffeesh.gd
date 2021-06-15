extends FishTemplate

onready var kinematic_body = $KinematicBody
onready var swim_to_random_pt = $KinematicBody/SwimToRandomPt
var movement_vector : Vector2


func _ready() -> void:
	set_up_progress_bar()
	

func _physics_process(delta) -> void:
	if !swim_to_random_pt.swimming:
		movement_vector = swim_to_random_pt.swim()
	elif swim_to_random_pt.reached_pt():
		pass
		
	kinematic_body.move_and_slide(movement_vector)
	update_fish_sprite_based_on_horizontal_direction(movement_vector)
