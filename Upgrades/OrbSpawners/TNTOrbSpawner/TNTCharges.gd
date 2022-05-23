extends Area2D

export(PackedScene) onready var attached_charge
export(PackedScene) onready var explosion

onready var qty_label = $Sprite/QtyLabel

var damage : float
var qty : int

func _ready() -> void:
	SfxManager.bobber.tnt.play("Carry")
	GameEvents.connect("detonated_charges", self, "explode")


func set_incremented_values(new_incremented_values) -> void:
	qty = new_incremented_values[0]
	qty_label.update_text(qty)
	damage = new_incremented_values[2]


func update_qty_from_orb(new_incremented_values) -> void:
	qty += new_incremented_values[0]
	qty_label.update_text(qty)


func _on_TNTCharges_area_entered(area):
	attach_charge_to_fish(area)
	qty -= 1
	if qty <= 0:
		queue_free()
	else:
		qty_label.update_text(qty)	


func attach_charge_to_fish(area) -> void:
	SfxManager.bobber.tnt.play("Attach charge")
	if !attached_charge_is_in(area):
		var attached_charge_instance = attached_charge.instance()
		attached_charge_instance.name = "attached_charge"
		area.get_parent().add_child(attached_charge_instance)
		attached_charge_instance.on_passed(damage)
		attached_charge_instance.global_position = area.get_parent().global_position
	else:
		area.get_parent().get_node("attached_charge").increment_qty()
	
	
	
func attached_charge_is_in(area) -> bool:
	return area.get_parent().has_node("attached_charge")


func explode() -> void:
	var triggered_instance = explosion.instance()	
	get_parent().get_parent().call_deferred("add_child", triggered_instance)
	triggered_instance.call_deferred("set_damage", damage * qty)
	triggered_instance.set_deferred("global_position", global_position)
	queue_free()
