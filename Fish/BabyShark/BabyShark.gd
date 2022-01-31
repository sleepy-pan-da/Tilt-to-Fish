extends FishTemplate

onready var kinematic_body = $KinematicBody
onready var detection_area = $KinematicBody/DetectionArea
onready var hitbox = $KinematicBody/HitBox
onready var swim_to_random_pt_based_on_radius = $KinematicBody/SwimToRandomPtBasedOnRadius
onready var follow_bobber = $KinematicBody/FollowBobber
onready var state_machine = $KinematicBody/StateMachine

export(int) var damage

var movement_vector : Vector2
var collision : KinematicCollision2D

# State Transitions
# ComputeNewPtToSwimTo -> Swimming
# Swimming -> ComputeNewPtToSwimTo
# ComputeNewPtToSwimTo / Swimming -> DetectedBobber
# DetectedBobber -> FollowBobber
# FollowBobber -> ComputeNewPtToSwimTo

func _ready() -> void:
	detection_area.connect("detected_bobber", self, "on_detected_bobber")
	detection_area.connect("lost_bobber", state_machine.get_node("FollowBobber"), "on_lost_bobber")
	hitbox.connect("bobber_entered_hitbox", self, "on_bobber_entered_hitbox")


# ComputeNewPtToSwimTo and Swimming can transition to this
func on_detected_bobber(bobber : Bobber) -> void:
	state_machine.transition_to("DetectedBobber", {detected_bobber = bobber})


func on_bobber_entered_hitbox() -> void:
	GameEvents.emit_signal("bobber_took_damage", damage)
