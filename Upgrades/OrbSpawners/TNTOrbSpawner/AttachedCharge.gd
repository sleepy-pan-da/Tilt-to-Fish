extends Node2D

export(PackedScene) onready var explosion

onready var qty_label = $Sprite/QtyLabel

var damage : float
var qty : int = 1

func _ready() -> void:
	GameEvents.connect("detonated_charges", self, "explode")


func on_passed(new_damage) -> void:
	damage = new_damage


func increment_qty() -> void:
	qty += 1
	qty_label.update_text(qty)


func explode() -> void:
	var triggered_instance = explosion.instance()
	var gamelevel_template_reference = get_parent().get_parent().get_parent().get_parent()
	gamelevel_template_reference.add_child(triggered_instance) 
	triggered_instance.set_damage(damage * qty)
	triggered_instance.global_position = global_position
	queue_free()
