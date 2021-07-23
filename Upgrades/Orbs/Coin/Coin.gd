extends Area2D


func _on_Coin_body_entered(body : Bobber):
	body.bobber_stats.increment_gold(1)
	body.update_damage()
	queue_free()
