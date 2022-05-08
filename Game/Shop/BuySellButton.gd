extends TextureButton

export(Texture) var BuyButtonTexture1Digit
export(Texture) var BuyButtonTexture2Digit
export(Texture) var SellButtonTexture1Digit
export(Texture) var SellButtonTexture2Digit

onready var tween = $Tween
var released_button : bool = false
signal clicked_buy_sell_button

func update_to_buy(item_cost : int) -> void:
	if item_cost >= 10: 
		texture_normal = BuyButtonTexture2Digit
	else:
		texture_normal = BuyButtonTexture1Digit


func update_to_sell(item_cost : int) -> void:
	if item_cost >= 10: 	
		texture_normal = SellButtonTexture2Digit
	else:
		texture_normal = SellButtonTexture1Digit


func _on_BuySellButton_button_down():
	tween.interpolate_property(self, "rect_scale", Vector2(1, 1), Vector2(0.9, 0.9), 0.08, Tween.TRANS_LINEAR)
	tween.start()


func _on_BuySellButton_button_up():
	released_button = true
	tween.interpolate_property(self, "rect_scale", Vector2(0.9, 0.9), Vector2(1, 1), 0.08, Tween.TRANS_LINEAR)
	tween.start()


func _on_Tween_tween_all_completed():
	if released_button:
		released_button = false
		emit_signal("clicked_buy_sell_button")
