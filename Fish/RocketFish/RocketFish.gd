extends FishTemplate


onready var kinematic_body = $KinematicBody
onready var hitbox = $KinematicBody/HitBox
onready var bounce_off_walls = $BounceOffWalls
export(int) var damage
var movement_vector : Vector2
var collision : KinematicCollision2D

func _ready() -> void:
	hitbox.connect("bobber_entered_hitbox", self, "on_bobber_entered_hitbox")
	movement_vector = bounce_off_walls.start_initial_movement()
	set_up_progress_bar()


func on_bobber_entered_hitbox() -> void:
	bobber_in_proximity_area.bobber_stats.minus_hook(damage)
	GameEvents.emit_signal("bobber_took_damage")


func _physics_process(delta) -> void:
	collision = kinematic_body.move_and_collide(movement_vector * delta)
	if collision:
		movement_vector = bounce_off_walls.compute_bounced_off_vector(collision, movement_vector)
	update_fish_sprite_based_on_horizontal_direction(movement_vector)
