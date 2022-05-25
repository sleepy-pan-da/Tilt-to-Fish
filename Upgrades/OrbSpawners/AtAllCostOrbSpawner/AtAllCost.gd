extends Area2D

onready var sprite = $Sprite
onready var tween = $Tween
var damage : float

func _ready():
	SfxManager.bobber.at_all_cost.play("At all cost")
	tween.interpolate_property(sprite, "modulate",
		Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()


func get_name() -> String:
	return "AtAllCost"


func set_incremented_values(new_incremented_values) -> void:
	damage = new_incremented_values[0]


func _on_Tween_tween_completed(object, key):
	queue_free()
