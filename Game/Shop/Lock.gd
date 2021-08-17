extends TextureButton

export(Texture) var unlock_button_texture
export(Texture) var lock_button_texture
onready var tween = $Tween

func _on_Lock_button_down() -> void:
	tween.interpolate_property(self, "rect_scale", Vector2(0.064, 0.064), Vector2(0.056, 0.056), 0.1, Tween.TRANS_LINEAR)
	tween.start()
		

func _on_Lock_button_up() -> void:
	if !pressed:
		texture_normal = lock_button_texture
	else:
		texture_normal = unlock_button_texture
	tween.interpolate_property(self, "rect_scale", Vector2(0.056, 0.056), Vector2(0.064, 0.064), 0.1, Tween.TRANS_LINEAR)
	tween.start()
