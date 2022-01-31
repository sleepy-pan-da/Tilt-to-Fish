extends FishTemplate

onready var kinematic_body = $KinematicBody
onready var lunge_at_bobber = $KinematicBody/LungeAtBobber
onready var detection_area = $KinematicBody/DetectionArea
onready var hitbox = $KinematicBody/HitBox
onready var state_machine = $KinematicBody/StateMachine

export(int) var damage

var movement_vector : Vector2
var collision : KinematicCollision2D
var stunned : bool = false

# State Transitions
# Alert -> ComputePtToLungeTowards
# ComputePtToLungeTowards -> Lunging
# Lunging -> Stunned
# Stunned -> RecoverFromStun
# RecoverFromStun -> ComputePtToLungeTowards

func _ready() -> void:
	detection_area.connect("detected_bobber", state_machine.get_node("Alert"), "on_detected_bobber")
	detection_area.connect("lost_bobber", self, "on_lost_bobber")
	hitbox.connect("bobber_entered_hitbox", self, "on_bobber_entered_hitbox")
	fish_sprite.connect("finished_recovering", state_machine.get_node("RecoverFromStun"), "on_finished_recovering")

# need this to solve for null reference when your bobber dies	
func on_lost_bobber() -> void:
	bobber_in_proximity_area = null


func on_bobber_entered_hitbox() -> void:
	GameEvents.emit_signal("bobber_took_damage", damage)
