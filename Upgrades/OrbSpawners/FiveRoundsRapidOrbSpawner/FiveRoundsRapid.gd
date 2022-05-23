extends StaticBody2D

export(PackedScene) var projectile
export(float) var projectile_speed
onready var animation_player = $AnimationPlayer
onready var muzzle = $Muzzle
onready var tween = $Tween
onready var firing_cooldown = $FiringCooldown

var damage : float
var detected_fish = [] #FIFO Queue
var is_rotating : bool = false

func _ready() -> void:
	SfxManager.bobber.five_rounds_rapid.play("Deploy")
	animation_player.play("SetUp")


func on_set_up_finished() -> void:
	firing_cooldown.start()


func _on_FiringCooldown_timeout():
	fire()


func fire() -> void:
	SfxManager.bobber.five_rounds_rapid.play("Fire")
	var new_projectile : TurretProjectile = projectile.instance()
	var level = get_parent()
	level.add_child(new_projectile)
	var direction : Vector2 = (muzzle.global_position - global_position).normalized()
	new_projectile.set_damage(damage)
	new_projectile.global_position = muzzle.global_position
	new_projectile.velocity = direction * projectile_speed


func set_incremented_values(new_incremented_values) -> void:
	damage = new_incremented_values[0]
	#print("FiveRoundsRapid damage is " + str(damage))


func _physics_process(delta):
	if detected_fish.empty():
		return
	if !is_rotating:
		rotate_if_needed()


func rotate_if_needed() -> void:
	var target = detected_fish.front()
	var desired_angle = (target.global_position - global_position).angle()
	var current_angle = (muzzle.global_position - global_position).angle()
	var angle_diff : float = abs(rad2deg(desired_angle - current_angle))
	
	if angle_diff > 180: # arrow will pick smallest angle of rotation
		# change direction for arrow movement
		if sign(desired_angle) == 1: 
			desired_angle -= 2*PI
		else:
			desired_angle += 2*PI
	
	if angle_diff > 2:#5:
		is_rotating = true
		tween.interpolate_method(self, "compute_turret_rotation", 
		current_angle, 
		desired_angle, 
		0.1, Tween.TRANS_SINE, Tween.EASE_OUT_IN)
		tween.start()


func _on_Tween_tween_completed(object, key):
	is_rotating = false


func compute_turret_rotation(angle_wrt_x_axis : float):
	rotate(angle_wrt_x_axis - rotation)
	
	
func _on_Lifespan_timeout():
	animation_player.play("Collapse")


func _exit_tree() -> void:
	SfxManager.bobber.five_rounds_rapid.play("Tear down")


func _on_Detection_body_entered(body):
	detected_fish.push_back(body)


func _on_Detection_body_exited(body):
	detected_fish.erase(body)
