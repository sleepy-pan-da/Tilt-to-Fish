extends Node2D

class_name FishTemplate

onready var fish_sprite = $KinematicBody/FishSprite
onready var ripple = $KinematicBody/RippleSprite
onready var ripple_animation = $KinematicBody/RippleAnimation
onready var progress_bar = $KinematicBody/ProgressBar
onready var check_bobber_in_proximity_area_timer = $CheckBobberInProximityAreaTimer
onready var recovery_timer = $RecoveryTimer

export(float) var amount_needed_to_catch = 100
export(float) var fish_recovery_amount = 0.5
var bobber_in_proximity_area : Bobber


func _ready() -> void:
	progress_bar.connect("progress_bar_filled", self, "_on_progress_bar_filled")
	progress_bar.connect("progress_bar_emptied", self, "_on_progress_bar_emptied")
	
	set_up_progress_bar() # need to call this again in ready of child class
	ripple.hide()

func _on_progress_bar_filled() -> void:
	queue_free()
	GameEvents.emit_signal("successfully_caught_fish")


func _on_progress_bar_emptied() -> void:
	progress_bar.disappear()
	

func set_up_progress_bar() -> void:
	progress_bar.set_max_value(amount_needed_to_catch)
	progress_bar.hide()


func _on_ProximityArea_body_entered(body : Bobber) -> void:
	obtain_bobber_reference(body) # first instance obtaining reference of bobber
	progress_bar.appear()
	enable_ripple()
	manage_timers_when_proximity_area_entered() 


func _on_ProximityArea_body_exited(_body : Bobber) -> void:
	disable_ripple()
	manage_timers_when_proximity_area_exited()
	

func enable_ripple() -> void:
	ripple.show()
	ripple_animation.play("Ripple")
	

func disable_ripple() -> void:
	ripple.hide()
	ripple_animation.stop(true)
	
	
func manage_timers_when_proximity_area_entered() -> void:
	var bobber_attack_rate : float = bobber_in_proximity_area.bobber_stats.bobber_attack_rate
	check_bobber_in_proximity_area_timer.start(bobber_attack_rate)
	recovery_timer.stop()
	

func manage_timers_when_proximity_area_exited() -> void:
	check_bobber_in_proximity_area_timer.stop()
	recovery_timer.start()
	
	
# will be called if you stay in proximity area for the duration of bobber's attack rate	
func _on_CheckBobberInProximityAreaTimer_timeout(): 
	
	var player_attack_amount = bobber_in_proximity_area.bobber_stats.bobber_attack_amount
	progress_bar.increment_bar(player_attack_amount)
	
	var bobber_attack_rate : float = bobber_in_proximity_area.bobber_stats.bobber_attack_rate
	check_bobber_in_proximity_area_timer.start(bobber_attack_rate)
	

# will be called every 0.1s when you leave proximity area until progress bar reaches zero
func _on_RecoveryTimer_timeout():
	progress_bar.decrement_bar(fish_recovery_amount)
	if progress_bar.value > 0:
		recovery_timer.start()


# need this if FixedPathMovement is attached to fish
func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)


func update_fish_sprite_based_on_horizontal_direction(movement_vector : Vector2) -> void:
	if movement_vector != Vector2.ZERO:
		var direction : Vector2 = movement_vector.normalized()
		if direction.x > 0.1 and fish_sprite.animation == "FacingLeft":
			fish_sprite.animation = "FacingRight"
		elif direction.x < -0.1 and fish_sprite.animation == "FacingRight":
			fish_sprite.animation = "FacingLeft"


func obtain_bobber_reference(bobber : Bobber) -> void:
	bobber_in_proximity_area = bobber
