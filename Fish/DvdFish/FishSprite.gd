extends FishTemplateFishSprite

export(Array, Color) var colours_of_dvd
var index : int = 0

func react_when_hit_wall() -> void:
	tween.interpolate_property(self, "scale", Vector2(0.08, 0.08), Vector2(0.063, 0.063), 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	change_colour()
	tween.start()


func change_colour() -> void:
	index += 1 
	index = index % colours_of_dvd.size()
	modulate = colours_of_dvd[index]
