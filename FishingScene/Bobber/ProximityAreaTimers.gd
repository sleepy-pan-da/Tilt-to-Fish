extends Node


func resume_all_timers() -> void:
	for timer in get_children():
		if timer.paused:
			timer.paused = false
		else:
			timer.start()


func pause_all_timers() -> void:
	for timer in get_children():
		timer.paused = true
