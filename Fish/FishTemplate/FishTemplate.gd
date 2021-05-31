extends Node2D

class_name Fish

onready var ripple = $KinematicBody/RippleSprite
onready var ripple_animation = $KinematicBody/RippleAnimation
onready var progress_bar = $KinematicBody/ProgressBar
onready var check_bobber_in_proximity_area_timer = $CheckBobberInProximityAreaTimer

var alerted : bool = false #will need this for fish types that react when you enter their proximity area
var amount_needed_to_catch : int = 100
var bobber_in_proximity_area : Bobber


func _ready() -> void:
	progress_bar.connect("progress_bar_filled", self, "_on_progress_bar_filled")

	set_up_progress_bar() #need to call this again in ready of child class
	ripple.hide()
	

func _on_progress_bar_filled() -> void:
	queue_free()


func set_up_progress_bar() -> void:
	progress_bar.set_max_value(amount_needed_to_catch)
	progress_bar.hide()


func _on_ProximityArea_body_entered(body : Bobber) -> void:
	alerted = true
	progress_bar.show()
	enable_ripple()
	check_bobber_in_proximity_area_timer.start()
	bobber_in_proximity_area = body #obtaining reference of bobber


func _on_ProximityArea_body_exited(body : Bobber) -> void:
	alerted = false
	progress_bar.hide()
	disable_ripple()
	check_bobber_in_proximity_area_timer.stop()
	

func enable_ripple() -> void:
	ripple.show()
	ripple_animation.play("Ripple")
	

func disable_ripple() -> void:
	ripple.hide()
	ripple_animation.stop(true)
	
	
#Will be called if you stay in proximity area for the duration of wait time	
func _on_CheckBobberInProximityAreaTimer_timeout(): 
	var player_attack_amount = bobber_in_proximity_area.bobber_stats.bobber_attack_amount
	progress_bar.increment_bar(player_attack_amount)
	check_bobber_in_proximity_area_timer.start()
	
