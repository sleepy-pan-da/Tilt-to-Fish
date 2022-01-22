extends TextureProgress

onready var timer = $Timer
signal finished_cooldown


func set_duration(duration : float) -> void:
	max_value = duration
	

func _on_Timer_timeout() -> void:
	value += timer.wait_time
	if value >= max_value:
		timer.stop()
		hide()
		emit_signal("finished_cooldown")
		

func start() -> void:
	timer.start()
