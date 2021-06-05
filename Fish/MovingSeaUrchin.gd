extends ScrubFish
class_name MovingSeaUrchin

export(int) var damage

func _ready():
	set_up_progress_bar()

func _on_HitBox_body_entered(body : Bobber) ->  void:
	bobber_in_proximity_area.bobber_stats.minus_hook(damage)
	GameEvents.emit_signal("bobber_took_damage")
