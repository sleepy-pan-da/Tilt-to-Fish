extends Area2D

onready var tween = $Tween

var damage : float
var expanded : bool = false

func _ready():
	SfxManager.bobber.plasma_field.play("Trigger")
	tween.interpolate_property(self, "scale",
		Vector2(0.5, 0.5), Vector2(3, 3), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()


func get_name() -> String:
	return "PlasmaField"


func set_value(new_damage : float):
	damage = new_damage


func _on_Tween_tween_completed(object, key):
	if !expanded:
		expanded = true
		tween.interpolate_property(self, "scale",
		Vector2(3, 3), Vector2(0.5, 0.5), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
	else:
		queue_free()
