extends TextureButton

export(Texture) var BuyButtonTexture
export(Texture) var SellButtonTexture

onready var tween = $Tween
var released_button : bool = false
signal clicked_buy_sell_button

func update_to_buy() -> void:
	texture_normal = BuyButtonTexture


func update_to_sell() -> void:
	texture_normal = SellButtonTexture


func _on_BuySellButton_button_down():
	tween.interpolate_property(self, "rect_scale", Vector2(1, 1), Vector2(0.7, 0.7), 0.08, Tween.TRANS_LINEAR)
	tween.start()


func _on_BuySellButton_button_up():
	released_button = true
	tween.interpolate_property(self, "rect_scale", Vector2(0.7, 0.7), Vector2(1, 1), 0.08, Tween.TRANS_LINEAR)
	tween.start()


func _on_Tween_tween_all_completed():
	if released_button:
		released_button = false
		emit_signal("clicked_buy_sell_button")
