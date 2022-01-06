extends TextureProgress

onready var timer = $Timer
var wave_duration : int = 30

func _ready() -> void:
	max_value = wave_duration


func increment_bar() -> void:
	value += 1


func _on_Timer_timeout() -> void:
	increment_bar()
	if timed_out():
		emit_signal("wave_timed_out")
	# value here (which represents time passed in wave) increases from 0 to 30


func timed_out() -> bool:
	return value >= max_value


func start_progress_bar_timer() -> void:
	timer.start()


func stop_progress_bar_timer():
	timer.stop()

func reset_progress_bar() -> void:
	timer.stop()
	value = 0
	start_progress_bar_timer()


func set_wave_duration(new_wave_duration : int) -> void:
	wave_duration = new_wave_duration
	max_value = wave_duration
	


