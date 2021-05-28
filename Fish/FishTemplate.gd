extends Node2D

class_name Fish

onready var ripple = $KinematicBody/RippleSprite
onready var ripple_animation = $KinematicBody/RippleAnimation

var alerted : bool = false


func _ready():
	ripple.hide()


func _on_ProximityArea_body_entered(body):
	alerted = true
	ripple.show()
	ripple_animation.play("Ripple")

func _on_ProximityArea_body_exited(body):
	alerted = false
	ripple.hide()
	ripple_animation.stop(true)
