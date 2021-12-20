extends FishTemplate

onready var kinematic_body = $KinematicBody
onready var swim_to_random_pt_based_on_radius = $KinematicBody/SwimToRandomPtBasedOnRadius

var movement_vector : Vector2
var collision : KinematicCollision2D
	
# State Transitions
# ComputeNewPtToSwimTo -> Swimming
# Swimming -> ReachedPt / Collided
# ReachedPt / Collided -> ComputeNewPtToSwimTo
