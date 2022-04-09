extends FishTemplate

onready var kinematic_body = $KinematicBody
onready var steering_behaviour = $KinematicBody/SteeringBehaviour
onready var detection_area = $KinematicBody/DetectionArea
onready var swim_to_random_pt_based_on_radius = $KinematicBody/SwimToRandomPtBasedOnRadius
onready var hitbox = $KinematicBody/HitBox
onready var collided_timer = $CollidedTimer
onready var fish_animation = $KinematicBody/FishAnimation

export(int) var damage
export(Resource) var initial_animated_sprites
export(Resource) var actual_animated_sprites

var movement_vector : Vector2
var collision : KinematicCollision2D
var morphed : bool = false # added this to handle stun

# State Transitions
# ComputeNewPtToSwimTo -> Swimming
# Swimming -> ComputeNewPtToSwimTo
# Swimming -> Morphing
# Morphing -> FollowBobber
# FollowBobber -> Stunned
# Stunned -> RecoverFromStun
# RecoverFromStun -> FollowBobber

func _ready() -> void:
	detection_area.connect("detected_bobber", self, "on_detected_bobber")
	detection_area.connect("lost_bobber", self, "on_lost_bobber")
	hitbox.connect("bobber_entered_hitbox", self, "on_bobber_entered_hitbox")
	#fish_sprite.connect("finished_recovering", state_machine.get_node("Recover"), "on_finished_recovering")
	set_up_initial_animated_sprites()
	

func on_detected_bobber(bobber : Bobber) -> void:
	obtain_bobber_reference(bobber)
	
	
func on_lost_bobber() -> void:
	bobber_in_proximity_area = null


func on_bobber_entered_hitbox() -> void:
	GameEvents.emit_signal("bobber_took_damage", damage)


# override function
func _on_ProximityArea_body_entered(body : Bobber) -> void:
	state_machine.get_node("Swimming")._on_ProximityArea_body_entered(body)
		
	# this happens regardless of state	
	obtain_bobber_reference(body)
	progress_bar.appear()
	enable_ripple()
	manage_timers_when_proximity_area_entered() 


func set_up_initial_animated_sprites() -> void:
	fish_sprite.frames = initial_animated_sprites


func set_up_actual_animated_sprites() -> void:
	fish_sprite.frames = actual_animated_sprites
