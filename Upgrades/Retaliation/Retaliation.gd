extends Node2D

class_name Retaliation

onready var aura = $Aura
var damage : float

func _ready() -> void:
	SfxManager.bobber.retaliation.play("Explode")

func _physics_process(delta):
	aura.frame += 1
	aura.frame += 1
	if aura.frame > 81:
		queue_free()


func get_class() -> String:
	return "Retaliation"


func set_value(new_damage : float):
	damage = new_damage
