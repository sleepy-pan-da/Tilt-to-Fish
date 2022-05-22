extends Node2D

onready var aura = $Aura
var damage : float

func _ready():
	SfxManager.bobber.against_all_odds.play("Explode")


func _physics_process(delta):
	aura.frame += 1
	aura.frame += 1
	if aura.frame > 81:
		queue_free()


func get_class() -> String:
	return "AgainstAllOdds"


func set_value(new_damage : float):
	damage = new_damage
