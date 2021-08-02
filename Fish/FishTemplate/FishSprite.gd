extends AnimatedSprite

class_name FishTemplateFishSprite

onready var tween = $Tween

func react_upon_getting_hurtbox_hit() -> void:
	tween.interpolate_property(self, "scale", Vector2(0, 0), Vector2(0.063, 0.063), 0.7, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()
