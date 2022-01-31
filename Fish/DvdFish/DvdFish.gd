extends FishTemplate


onready var kinematic_body = $KinematicBody
onready var hitbox = $KinematicBody/HitBox
onready var bounce_off_walls = $BounceOffWalls
export(int) var damage

var movement_vector : Vector2
var collision : KinematicCollision2D

func _ready() -> void:
	hitbox.connect("bobber_entered_hitbox", self, "on_bobber_entered_hitbox")


func on_bobber_entered_hitbox() -> void:
	GameEvents.emit_signal("bobber_took_damage", damage)

# State Transitions
# StartInitialMovement -> Swimming
# Swimming -> Collided
# Collided -> ComputeNewPtToSwimTo
# ComputeNewPtToSwimTo -> Swimming

