extends Area2D

class_name FishHitbox
signal bobber_entered_hitbox

# to hurt other fishes, need to check the ThingsThatHitFishHurtbox layer

# this is added to solve the problem introduced by bullfish being able
# to hurt fishes that it passed thru, the problem being
# bullfish hurting itself at the start
export(bool) var within_hurtbox
var can_deal_damage : bool = false


func _on_HitBox_body_entered(body : Bobber) -> void:
	if !body.is_immune:
		emit_signal("bobber_entered_hitbox")


func get_class() -> String:
	return "FishHitbox"
