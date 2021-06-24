extends TextureProgress

onready var timer = $Timer

func increment_bar() -> void:
	value += 1
	if value >= max_value:
		value = 0


func _on_Timer_timeout():
	increment_bar()


func start_progress_bar_timer():
	timer.start()


func reset_progress_bar():
	timer.stop()
	value = 0
	start_progress_bar_timer()
