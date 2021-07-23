extends KinematicBody2D

class_name AlphaOrbs

onready var sprite = $Sprite
var damage : float


func get_class() -> String:
	return "AlphaOrbs" 


func react_upon_contact() -> void:
	sprite.expand()
