extends Area2D

onready var sprite = $Sprite
onready var tween = $Tween

var damage : float

func get_name() -> String:
	return "Acid"


func set_value(new_damage : float):
	damage = new_damage


func _on_Lifespan_timeout():
	tween.interpolate_property(sprite, "modulate",
		Color(0, 1, 0.06, 0.49), Color(0, 1, 0.06, 0), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()


func _on_Tween_tween_completed(object, key):
	queue_free()
