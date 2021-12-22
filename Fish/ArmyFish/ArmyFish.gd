extends FishTemplate

export(int) var damage
export(int) var number_of_projectiles_shot_each_round
export(int) var time_between_each_shot

onready var state_machine = $KinematicBody/StateMachine
onready var shoot_projectiles = $KinematicBody/ShootProjectiles
onready var detection_area = $KinematicBody/DetectionArea
onready var rest_timer = $KinematicBody/ShootProjectiles/RestTimer

# State Transitions
# Alert -> Firing
# Firing -> Resting
# Resting -> Firing
# Resting -> CannotFire
# CannotFire -> Resting

func _ready() -> void:
	shoot_projectiles.connect("fired_projectile", self, "on_fired_projectile")
	detection_area.connect("detected_bobber", state_machine.get_node("Alert"), "on_detected_bobber")
	detection_area.connect("lost_bobber", self, "on_lost_bobber")


func on_fired_projectile(projectile : Projectile) -> void:
	projectile.connect("bobber_entered_hitbox", self, "on_bobber_entered_hitbox")
	
	
func on_bobber_entered_hitbox() -> void:
	bobber_in_proximity_area.bobber_stats.minus_hook(damage)
	GameEvents.emit_signal("bobber_took_damage", damage)


# need this to solve for null reference when your bobber dies
func on_lost_bobber() -> void:
	bobber_in_proximity_area = null
	

func fire_projectiles() -> void:
	for i in range(number_of_projectiles_shot_each_round):
		shoot_projectiles.fire(bobber_in_proximity_area.global_position)
		fish_sprite.react_upon_fire()
		yield(get_tree().create_timer(time_between_each_shot), 'timeout')


# override function - this stops the firing
func _on_ProximityArea_body_entered(body : Bobber) -> void:
	state_machine.get_node("Resting")._on_ProximityArea_body_entered(body)
	
	# this happens regardless of state
	obtain_bobber_reference(body) 
	progress_bar.appear()
	enable_ripple()
	manage_timers_when_proximity_area_entered() 
	if body.backpack.has_item("Poke"):
		progress_bar.increment_bar(body.bobber_stats.poke_damage)


# override function - this resumes the firing
func _on_ProximityArea_body_exited(body : Bobber) -> void:
	state_machine.get_node("CannotFire")._on_ProximityArea_body_exited(body)

	# this happens regardless of state
	disable_ripple()
	manage_timers_when_proximity_area_exited()
	if body.backpack.has_item("Pull Out"):
		progress_bar.appear()
		progress_bar.increment_bar(body.bobber_stats.pull_out_damage)
