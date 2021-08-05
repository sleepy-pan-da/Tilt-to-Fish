extends TextureProgress

onready var timer = $Timer

func set_up_progress_bar() -> void:
	show()
	value = 0
	timer.start()

func _on_Timer_timeout():
	value += 1
	if value >= max_value:
		hide()
	else:
		timer.start()
