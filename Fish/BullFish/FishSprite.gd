extends AnimatedSprite

onready var tween = $Tween

func react_when_stunned() -> void:
	tween.interpolate_property(self, "scale", Vector2(0.08, 0.08), Vector2(0.063, 0.063), 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()


func react_when_recovered() -> void:
	tween.interpolate_property(self, "scale", Vector2(0, 0), Vector2(0.063, 0.063), 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()
