extends TextureProgress

onready var timer = $Timer
var wave_duration : int = 30
var black_mamba : bool = false # will be toggled true if have black_mamba in backpack
var turned_black_mamba : bool = false # will be toggled back to false if it's effects are reseted upon new wave
var enthusiasm : bool = false # will be toggled true if have enthusiasm in backpack
var turned_unenthusiastic : bool = false # will be toggled back to false if it's effects are reseted upon new wave
signal wave_timed_out
signal turned_black_mamba
signal ran_out_of_enthusiasm

func _ready() -> void:
	max_value = wave_duration


func increment_bar() -> void:
	value += 1


func _on_Timer_timeout() -> void:
	increment_bar()
	if timed_out():
		emit_signal("wave_timed_out")
	# value here (which represents time passed in wave) increases from 0 to 30
	if value >= wave_duration - 15:
		if black_mamba and !turned_black_mamba:
			turned_black_mamba = true
			emit_signal("turned_black_mamba")
	if value == 10:
		if enthusiasm:
			turned_unenthusiastic = true
			emit_signal("ran_out_of_enthusiasm")
			

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
	


