extends FishTemplate

export(int) var damage
onready var shoot_projectiles = $KinematicBody/ShootProjectiles
onready var detection_area = $KinematicBody/DetectionArea
onready var timer = $KinematicBody/ShootProjectiles/Timer


func _ready() -> void:
	shoot_projectiles.connect("fired_projectile", self, "on_fired_projectile")
	detection_area.connect("detected_bobber", self, "on_detected_bobber")
	detection_area.connect("lost_bobber", self, "on_lost_bobber")
	set_up_progress_bar()


func on_fired_projectile(projectile : Projectile) -> void:
	projectile.connect("bobber_entered_hitbox", self, "on_bobber_entered_hitbox")
	
	
func on_bobber_entered_hitbox() -> void:
	bobber_in_proximity_area.bobber_stats.minus_hook(damage)
	GameEvents.emit_signal("bobber_took_damage")


# will be called when bobber spawns due to large detection area
# this starts the firing
func on_detected_bobber(bobber : Bobber) -> void:
	obtain_bobber_reference(bobber)
	shoot_projectiles.fire(bobber.global_position)
	timer.start()


# need this to solve for null reference
func on_lost_bobber() -> void:
	bobber_in_proximity_area = null


# resumes firing after timeout
func _on_Timer_timeout() -> void:
	if bobber_in_proximity_area != null:
		shoot_projectiles.fire(bobber_in_proximity_area.global_position)
		timer.start()


# this stops the firing
func _on_ProximityArea_body_entered(body : Bobber) -> void:
	if !timer.is_stopped():
		timer.stop()
	obtain_bobber_reference(body) 
	progress_bar.show()
	enable_ripple()
	manage_timers_when_proximity_area_entered() 
	

# this resumes the firing
func _on_ProximityArea_body_exited(_body : Bobber) -> void:
	if timer.is_stopped():
		timer.start()
	disable_ripple()
	manage_timers_when_proximity_area_exited()
	
	
