extends FishTemplate

onready var kinematic_body = $KinematicBody
onready var lunge_at_bobber = $KinematicBody/LungeAtBobber
onready var detection_area = $KinematicBody/DetectionArea
onready var hitbox = $KinematicBody/HitBox
export(int) var damage
var movement_vector : Vector2
var collision : KinematicCollision2D
var stunned : bool = false

func _ready() -> void:
	detection_area.connect("detected_bobber", self, "on_detected_bobber")
	detection_area.connect("lost_bobber", self, "on_lost_bobber")
	hitbox.connect("bobber_entered_hitbox", self, "on_bobber_entered_hitbox")
	lunge_at_bobber.connect("recovered_from_stun", self, "on_recovered_from_stun")
	fish_sprite.connect("ready_to_attack", self, "on_ready_to_attack")
	set_up_progress_bar()


func on_detected_bobber(bobber : Bobber) -> void:
	obtain_bobber_reference(bobber)
	
	
func on_lost_bobber() -> void:
	bobber_in_proximity_area = null


func on_bobber_entered_hitbox() -> void:
	bobber_in_proximity_area.bobber_stats.minus_hook(damage)
	GameEvents.emit_signal("bobber_took_damage", damage)
	

func _physics_process(delta) -> void:
	if bobber_in_proximity_area != null and !lunge_at_bobber.lunging: 
		movement_vector = lunge_at_bobber.lunge(bobber_in_proximity_area)
	
	collision = kinematic_body.move_and_collide(movement_vector * delta)
	if collision and collision.collider.is_in_group("PondBoundary"): 
		if !lunge_at_bobber.stunned:
			lunge_at_bobber.stunned()
			fish_sprite.react_when_stunned()
			movement_vector = Vector2.ZERO
	
	update_fish_sprite_based_on_horizontal_direction(movement_vector)


func on_recovered_from_stun() -> void:
	fish_sprite.react_when_recovering()


func on_ready_to_attack() -> void:
	lunge_at_bobber.recovered_from_stun_and_ready_to_attack()
