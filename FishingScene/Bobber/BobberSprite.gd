extends Sprite

onready var tween = $Tween

func react() -> void:
	tween.interpolate_property(self, "scale", Vector2(0, 0), Vector2(0.047, 0.047), 0.8, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()


func set_rejuvenated() -> void:
	modulate = Color.black


func reset() -> void:
	modulate = Color.white
