extends AnimatedSprite

onready var tween = $Tween

func react_upon_fire() -> void:
	tween.interpolate_property(self, "scale", Vector2(0, 0), Vector2(0.063, 0.063), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()
