extends Area2D

onready var sprite = $Sprite
onready var tween = $Tween
var damage : float
var stun_duration : float = 1

func _ready():
	tween.interpolate_property(sprite, "modulate",
		Color(0, 0, 1, 1), Color(0, 0, 1, 0), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()


func get_name() -> String:
	return "Thunder"


func set_incremented_values(new_incremented_values) -> void:
	damage = new_incremented_values[0]


func _on_Tween_tween_completed(object, key):
	queue_free()
