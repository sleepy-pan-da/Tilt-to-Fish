extends FishTemplate

export(int) var damage
export(int) var number_of_projectiles_shot_each_round
export(int) var time_between_each_shot
onready var shoot_projectiles = $KinematicBody/ShootProjectiles
onready var detection_area = $KinematicBody/DetectionArea
onready var timer = $KinematicBody/ShootProjectiles/Timer
var can_fire : bool = true


func _ready() -> void:
	shoot_projectiles.connect("fired_projectile", self, "on_fired_projectile")
	detection_area.connect("detected_bobber", self, "on_detected_bobber")
	detection_area.connect("lost_bobber", self, "on_lost_bobber")
	detection_area.disable_detection_area()
	set_up_progress_bar()


func on_fired_projectile(projectile : Projectile) -> void:
	projectile.connect("bobber_entered_hitbox", self, "on_bobber_entered_hitbox")
	
	
func on_bobber_entered_hitbox() -> void:
	bobber_in_proximity_area.bobber_stats.minus_hook(damage)
	GameEvents.emit_signal("bobber_took_damage", damage)


# will be called when bobber spawns due to large detection area
# this starts the firing
func on_detected_bobber(bobber : Bobber) -> void:
	obtain_bobber_reference(bobber)
	if can_fire:
		fire_projectiles()
	

func fire_projectiles() -> void:
	for i in range(number_of_projectiles_shot_each_round):
		shoot_projectiles.fire(bobber_in_proximity_area.global_position)
		fish_sprite.react_upon_fire()
		yield(get_tree().create_timer(time_between_each_shot), 'timeout')
	timer.start()

# need this to solve for null reference
func on_lost_bobber() -> void:
	bobber_in_proximity_area = null


# resumes firing after timeout
func _on_Timer_timeout() -> void:
	if bobber_in_proximity_area != null:
		fire_projectiles()


# this stops the firing
func _on_ProximityArea_body_entered(body : Bobber) -> void:
	if can_fire:
		timer.stop()
		can_fire = false
	obtain_bobber_reference(body) 
	progress_bar.appear()
	enable_ripple()
	manage_timers_when_proximity_area_entered() 
	if body.bobber_stats.can_poke:
		progress_bar.increment_bar(body.bobber_stats.poke_damage)

# this resumes the firing
func _on_ProximityArea_body_exited(body : Bobber) -> void:
	if !can_fire:
		timer.start()
		can_fire = true
	disable_ripple()
	manage_timers_when_proximity_area_exited()
	if body.bobber_stats.can_pull_out:
		progress_bar.appear()
		progress_bar.increment_bar(body.bobber_stats.pull_out_damage)


func _on_InitialSetUpTimer_timeout():
	detection_area.enable_detection_area()
