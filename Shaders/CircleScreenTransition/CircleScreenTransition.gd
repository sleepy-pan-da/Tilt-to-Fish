extends ColorRect

onready var tween = $Tween
var black_screen : bool = true
signal transitioned_out


func _ready():
	# Having it here helps update the rect_min_size upon changing to a new scene
	# if window size would to be changed
	rect_min_size = OS.get_real_window_size()
	

func transition_in() -> void:
	print(OS.get_real_window_size())
	material.set_shader_param("screen_width", rect_min_size.x)
	material.set_shader_param("screen_height", rect_min_size.y)
	tween.interpolate_property(material, "shader_param/circle_size", 0, 1.05, 0.75, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	tween.start()
	black_screen = false


func transition_out() -> void:
	material.set_shader_param("screen_width", rect_min_size.x)
	material.set_shader_param("screen_height", rect_min_size.y)
	tween.interpolate_property(material, "shader_param/circle_size", 1.05, 0, 0.75, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	tween.start() 
	black_screen = true



func _on_Tween_tween_all_completed():
	if black_screen:
		emit_signal("transitioned_out")
