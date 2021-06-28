extends AnimatedSprite

onready var tween = $Tween

func react_when_hit_wall() -> void:
	tween.interpolate_property(self, "scale", Vector2(0.08, 0.08), Vector2(0.063, 0.063), 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
