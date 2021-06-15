extends FishTemplate

onready var kinematic_body = $KinematicBody
onready var detection_area = $KinematicBody/DetectionArea
onready var hitbox = $KinematicBody/HitBox
onready var swim_to_random_pt = $KinematicBody/SwimToRandomPt
onready var follow_bobber = $KinematicBody/FollowBobber
export(int) var damage
var detected_bobber : bool = false
var movement_vector : Vector2
var collision : KinematicCollision2D


func _ready() -> void:
	detection_area.connect("detected_bobber", self, "on_detected_bobber")
	detection_area.connect("lost_bobber", self, "on_lost_bobber")
	hitbox.connect("bobber_entered_hitbox", self, "on_bobber_entered_hitbox")
	set_up_progress_bar()


func on_detected_bobber(bobber : Bobber) -> void:
	detected_bobber = true
	obtain_bobber_reference(bobber)
	
	
func on_lost_bobber() -> void:
	detected_bobber = false


func on_bobber_entered_hitbox() -> void:
	bobber_in_proximity_area.bobber_stats.minus_hook(damage)
	GameEvents.emit_signal("bobber_took_damage")
	

func _physics_process(delta) -> void:
	if detected_bobber:
		movement_vector = follow_bobber.compute_vector_to_move_towards_bobber(bobber_in_proximity_area)
		swim_to_random_pt.swimming = false
	else:
		if !swim_to_random_pt.swimming:
			movement_vector = swim_to_random_pt.swim()
		elif swim_to_random_pt.reached_pt():
			pass
	
	collision = kinematic_body.move_and_collide(movement_vector * delta)
	if collision and collision.collider.is_in_group("PondBoundary"): 
		# baby shark hit the walls alr, need to swim to other places
		movement_vector = swim_to_random_pt.swim()
		
	update_fish_sprite_based_on_horizontal_direction(movement_vector)
		
