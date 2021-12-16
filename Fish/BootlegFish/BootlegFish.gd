extends FishTemplate

onready var kinematic_body = $KinematicBody
onready var steering_behaviour = $KinematicBody/SteeringBehaviour
onready var detection_area = $KinematicBody/DetectionArea
onready var swim_to_random_pt_based_on_radius = $KinematicBody/SwimToRandomPtBasedOnRadius
onready var hitbox = $KinematicBody/HitBox
onready var stunned_timer = $StunnedTimer
onready var fish_animation = $KinematicBody/FishAnimation
export(int) var damage
export(Resource) var initial_animated_sprites
export(Resource) var actual_animated_sprites
var movement_vector : Vector2
var collision : KinematicCollision2D
var entered_proximity_area : bool = false
var stunned : bool = false
var morphing : bool = false

func _ready() -> void:
	detection_area.connect("detected_bobber", self, "on_detected_bobber")
	detection_area.connect("lost_bobber", self, "on_lost_bobber")
	hitbox.connect("bobber_entered_hitbox", self, "on_bobber_entered_hitbox")
	set_up_initial_animated_sprites()
	

func on_detected_bobber(bobber : Bobber) -> void:
	obtain_bobber_reference(bobber)
	
	
func on_lost_bobber() -> void:
	bobber_in_proximity_area = null


func on_bobber_entered_hitbox() -> void:
	bobber_in_proximity_area.bobber_stats.minus_hook(damage)
	GameEvents.emit_signal("bobber_took_damage", damage)


# override function
func _on_ProximityArea_body_entered(body : Bobber) -> void:
	if !entered_proximity_area:
		entered_proximity_area = true # added functionality, fish will only attack when this is true to bait players
		fish_animation.play("Morph")
		fish_sprite.react_when_proximity_area_first_entered()
	obtain_bobber_reference(body)
	progress_bar.appear()
	enable_ripple()
	manage_timers_when_proximity_area_entered() 
	

func _physics_process(delta) -> void:
	if morphing:
		return
		
	if entered_proximity_area and bobber_in_proximity_area != null: # if this is true, it will forever be true, fish just keeps lunging at you
		if !stunned:
			movement_vector = steering_behaviour.compute_new_velocity(bobber_in_proximity_area)
	else:
		if !swim_to_random_pt_based_on_radius.swimming:
			movement_vector = swim_to_random_pt_based_on_radius.swim()
		elif swim_to_random_pt_based_on_radius.reached_pt():
			pass
	
		
	collision = kinematic_body.move_and_collide(movement_vector * delta)
	
	if collision and collision.collider.is_in_group("PondBoundary"): 
		if !entered_proximity_area:
			movement_vector = swim_to_random_pt_based_on_radius.swim()
		elif entered_proximity_area and !stunned:
			stunned = true
			stunned_timer.start()
			movement_vector = Vector2.ZERO
			
		
	update_fish_sprite_based_on_horizontal_direction(movement_vector)


func _on_StunnedTimer_timeout():
	stunned = false
	steering_behaviour.reset_current_velocity()


func set_up_initial_animated_sprites() -> void:
	fish_sprite.frames = initial_animated_sprites


func set_up_actual_animated_sprites() -> void:
	fish_sprite.frames = actual_animated_sprites


func set_morphing(value : bool) -> void:
	morphing = value
