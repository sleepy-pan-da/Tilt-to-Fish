extends Node2D

class_name FishTemplate

onready var fish_sprite = $KinematicBody/FishSprite
onready var ripple = $KinematicBody/RippleSprite
onready var ripple_animation = $KinematicBody/RippleAnimation
onready var progress_bar = $KinematicBody/ProgressBar
onready var check_bobber_in_proximity_area_timer = $CheckBobberInProximityAreaTimer
onready var recovery_timer = $RecoveryTimer

export(float) var amount_needed_to_catch
export(float) var fish_recovery_amount
var bobber_in_proximity_area : Bobber

func _ready() -> void:
	progress_bar.connect("progress_bar_filled", self, "_on_progress_bar_filled")
	progress_bar.connect("progress_bar_emptied", self, "_on_progress_bar_emptied")
	
	set_up_progress_bar()
	ripple.hide()

func _on_progress_bar_filled() -> void:
	queue_free()
	GameEvents.emit_signal("successfully_caught_fish", get_node("KinematicBody").global_position)


func _on_progress_bar_emptied() -> void:
	progress_bar.disappear()
	

func set_up_progress_bar() -> void:
	progress_bar.set_max_value(amount_needed_to_catch)
	progress_bar.hide()
	#print(progress_bar.max_value)

func _on_ProximityArea_body_entered(body : Bobber) -> void:
	obtain_bobber_reference(body) # first instance obtaining reference of bobber
	progress_bar.appear()
	enable_ripple()
	manage_timers_when_proximity_area_entered() 


func _on_ProximityArea_body_exited(body : Bobber) -> void:
	disable_ripple()
	manage_timers_when_proximity_area_exited()


func enable_ripple() -> void:
	ripple.show()
	ripple_animation.play("Ripple")
	

func disable_ripple() -> void:
	ripple.hide()
	ripple_animation.stop(true)
	
	
func manage_timers_when_proximity_area_entered() -> void:
	var bobber_attack_rate : float = bobber_in_proximity_area.bobber_stats.reel_attack_rate
	var time_to_next_reel_attack : float = 1 / bobber_attack_rate
	check_bobber_in_proximity_area_timer.start(time_to_next_reel_attack)
	recovery_timer.stop()
	

func manage_timers_when_proximity_area_exited() -> void:
	check_bobber_in_proximity_area_timer.stop()
	recovery_timer.start()
	
	
# will be called if you stay in proximity area for the duration of bobber's attack rate	
func _on_CheckBobberInProximityAreaTimer_timeout(): 
	var player_attack_amount = bobber_in_proximity_area.bobber_stats.reel_damage
	progress_bar.increment_bar(player_attack_amount)
	
	var bobber_attack_rate : float = bobber_in_proximity_area.bobber_stats.reel_attack_rate
	var time_to_next_reel_attack : float = 1 / bobber_attack_rate
	check_bobber_in_proximity_area_timer.start(time_to_next_reel_attack)
	

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


func _on_Hurtbox_body_entered(body):
	if body.get_class() == "AlphaOrbs":
		progress_bar.appear()
		fish_sprite.react_upon_getting_hurtbox_hit()
		progress_bar.increment_bar(body.damage)
	elif body.get_class() == "GammaOrbs":
		progress_bar.appear()
		fish_sprite.react_upon_getting_hurtbox_hit()
		progress_bar.increment_bar(body.damage)


func _on_Hurtbox_area_entered(area):
	progress_bar.appear()
	fish_sprite.react_upon_getting_hurtbox_hit()
	
	if area.get_class() == "Intimidate" or area.get_class() == "Retaliation":
		progress_bar.increment_bar(area.damage)
	elif area.get_class() == "Projectile":
		progress_bar.increment_bar(amount_needed_to_catch * 0.25)
		area.queue_free()
	elif area.get_name() == "Arrow":
		progress_bar.increment_bar(area.damage)
		area.queue_free()
	elif area.get_name() == "AntimatterWave":
		progress_bar.increment_bar(area.damage)
	elif area.get_class() == "FishHitbox":
		if area.within_hurtbox:
			if !area.can_deal_damage:
				area.can_deal_damage = true
			else:
				progress_bar.increment_bar(amount_needed_to_catch * 0.2)
	

func make_fish_tankier_with_difficulty_modifier(difficulty_modifier : int):
	amount_needed_to_catch *= pow(1.5, difficulty_modifier)
	amount_needed_to_catch = round(amount_needed_to_catch) 
	# if not rounded, amount_needed to catch might have more than 1dp. 
	# Step of progress bar is now 0.1. this might result in the case where u never catch the fish
