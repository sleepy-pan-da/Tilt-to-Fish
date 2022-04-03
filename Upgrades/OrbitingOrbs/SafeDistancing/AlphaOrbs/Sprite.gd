extends Sprite

onready var tween = $Tween
var need_to_contract : bool = false

func expand() -> void:
	need_to_contract = true
	tween.interpolate_property(self, "scale", Vector2(0, 0), Vector2(2, 2), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()


func contract() -> void:
	need_to_contract = false
	tween.interpolate_property(self, "scale", Vector2(2, 2), Vector2(1, 1), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()


func _on_Tween_tween_all_completed():
	if need_to_contract:
		contract()
