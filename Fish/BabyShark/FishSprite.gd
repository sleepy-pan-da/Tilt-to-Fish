extends AnimatedSprite

onready var tween = $Tween

func react_when_proximity_area_entered() -> void:
	tween.interpolate_property(self, "scale", Vector2(0, 0), Vector2(0.063, 0.063), 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()
