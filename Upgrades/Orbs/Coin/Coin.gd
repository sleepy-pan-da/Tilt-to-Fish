extends Area2D

signal bobber_touched_coin

func _on_Coin_body_entered(body : Bobber):
	body.bobber_stats.increment_gold(1)
	body.update_damage()
	emit_signal("bobber_touched_coin")
	queue_free()
