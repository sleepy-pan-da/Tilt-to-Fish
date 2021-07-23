extends KinematicBody2D

class_name GammaOrbs

onready var sprite = $Sprite
var damage : float

func get_class() -> String:
	return "GammaOrbs" 


func react_upon_contact() -> void:
	sprite.expand()
