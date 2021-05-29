extends Node2D

class_name Fish

onready var ripple = $KinematicBody/RippleSprite
onready var ripple_animation = $KinematicBody/RippleAnimation
onready var progress_bar = $ProgressBar
onready var check_bobber_in_proximity_area_timer = $CheckBobberInProximityAreaTimer

var alerted : bool = false
var amount_needed_to_catch : int = 100
var bobber_in_proximity_area : Bobber


func _ready() -> void:
	#Signal connections
	progress_bar.connect("progress_bar_filled", self, "_on_progress_bar_filled")
	set_up_progress_bar()
	ripple.hide()
	

func _on_progress_bar_filled() -> void:
	queue_free()


func set_up_progress_bar() -> void:
	progress_bar.set_max_value(amount_needed_to_catch)
	progress_bar.configure_offset()
	progress_bar.hide()


func _on_ProximityArea_body_entered(body : Bobber) -> void:
	alerted = true
	progress_bar.show()
	ripple.show()
	ripple_animation.play("Ripple")
	check_bobber_in_proximity_area_timer.start()
	bobber_in_proximity_area = body


func _on_ProximityArea_body_exited(body : Bobber) -> void:
	alerted = false
	progress_bar.hide()
	ripple.hide()
	ripple_animation.stop(true)
	check_bobber_in_proximity_area_timer.stop()
	

func _on_CheckBobberInProximityAreaTimer_timeout():
	var player_attack_amount = bobber_in_proximity_area.bobber_stats.bobber_attack_amount
	progress_bar.increment_bar(player_attack_amount)
	check_bobber_in_proximity_area_timer.start()
	
