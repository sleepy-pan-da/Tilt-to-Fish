extends ColorRect

onready var tween = $Tween
var black_screen : bool = true
signal transitioned_out

func transition_in() -> void:
	material.set_shader_param("screen_width", 1280)
	material.set_shader_param("screen_height", 720)
	tween.interpolate_property(material, "shader_param/circle_size", 0, 1.05, 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	tween.start()
	black_screen = false


func transition_out() -> void:
	material.set_shader_param("screen_width", 1280)
	material.set_shader_param("screen_height", 720)
	tween.interpolate_property(material, "shader_param/circle_size", 1.05, 0, 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	tween.start() 
	black_screen = true



func _on_Tween_tween_all_completed():
	if black_screen:
		emit_signal("transitioned_out")
