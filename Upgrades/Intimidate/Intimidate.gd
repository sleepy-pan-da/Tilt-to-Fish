extends Area2D

onready var tween = $Tween

var stun_duration : float

func _ready():
	tween.interpolate_property(self, "scale",
		Vector2(0.5, 0.5), Vector2(2, 2), 0.3,
		Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()


func get_name() -> String:
	return "Intimidate"


func set_value(new_stun_duration : float):
	stun_duration = new_stun_duration


func _on_Tween_tween_completed(object, key):
	queue_free()
