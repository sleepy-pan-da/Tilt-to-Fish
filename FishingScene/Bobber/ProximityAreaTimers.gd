extends Node


func resume_all_timers() -> void:
	for timer in get_children():
		if timer.paused:
			timer.paused = false
		else:
			timer.start()
		#print("resume timer with " + str(timer.time_left) + "s")

func pause_all_timers() -> void:
	for timer in get_children():
		timer.paused = true
		#print("pause timer with " + str(timer.time_left) + "s")
	
	
