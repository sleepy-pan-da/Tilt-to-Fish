extends Button

onready var tween = $Label/Tween
onready var toggle_bobber_label = $Label
var released_button : bool = false
var bobber_present : bool = false
signal clicked_toggle_bobber(bobber_in_scene)

func _on_ToggleBobberButton_button_down():
	tween.interpolate_property(toggle_bobber_label, "rect_scale", Vector2(1,1), Vector2(0.9, 0.9), 0.1, Tween.TRANS_LINEAR)
	tween.start()


func _on_ToggleBobberButton_button_up():
	released_button = true
	tween.interpolate_property(toggle_bobber_label, "rect_scale", Vector2(0.9,0.9), Vector2(1, 1), 0.1, Tween.TRANS_LINEAR)
	tween.start()


func _on_Tween_tween_all_completed() -> void:
	if released_button:
		released_button = false
		emit_signal("clicked_toggle_bobber", bobber_present)
		bobber_present = !bobber_present
