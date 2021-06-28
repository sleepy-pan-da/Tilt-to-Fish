extends Node2D

onready var tween = $Tween
var present : bool = true

func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		expand()
	elif Input.is_action_just_pressed("ui_right"):
		contract()


func expand():
	present = true
	tween.interpolate_property(self, "scale", Vector2(0, 0), Vector2(1, 1), 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.interpolate_property(self, "modulate:a", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()


func contract():
	present = false
	tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(0, 0), 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "modulate:a", 1, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()



func _on_Tween_tween_all_completed():
	if present:
		contract()
