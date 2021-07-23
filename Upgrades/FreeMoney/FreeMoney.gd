extends Node2D

export(PackedScene) var coin
onready var timer = $Timer
signal created_coin(coin)

func _on_Timer_timeout() -> void:
	create_coin()


func create_coin() -> void:
	var current_coin = coin.instance()
	emit_signal("created_coin", current_coin)


func set_timer(new_time) -> void:
	timer.wait_time = new_time


func start_timer() -> void:
	timer.start()
