extends KinematicBody2D

onready var sprite = $Sprite
var damage : float
var stun_duration : float = 1

func get_name() -> String:
	return "AlphaOrbs" 


func react_upon_contact() -> void:
	sprite.expand()
