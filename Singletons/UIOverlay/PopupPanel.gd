extends PopupPanel

onready var prophecy_contents = $ProphecyContents
onready var tween = $Tween
onready var duration_before_fade = $DurationBeforeFade

var hiding_position : Vector2

func _ready() -> void:
	hiding_position = rect_position
	
func show_up(prophecy : Prophecy = null) -> void:
	load_initial_set_up()
	prophecy_contents.update_contents(prophecy)
	show()
	tween.interpolate_property(self, "rect_position", hiding_position, hiding_position - Vector2(0, 112), 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()

func load_initial_set_up() -> void:
	tween.remove_all()
	duration_before_fade.stop()
	modulate.a = 1

func _on_Tween_tween_all_completed() -> void:
	if modulate.a == 1:
		duration_before_fade.start()
	elif modulate.a == 0:
		visible = false
		modulate.a = 1
		emit_signal("popup_hide")

func _on_DurationBeforeFade_timeout() -> void:
	tween.interpolate_property(self, "modulate:a",
		1, 0, 1,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
