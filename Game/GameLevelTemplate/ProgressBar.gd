extends TextureProgress

onready var timer = $Timer
var wave_duration : int = 30

func _ready() -> void:
	max_value = wave_duration


func compute_wave_duration() -> void:
	pass

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
