extends Control


onready var label = $Label
onready var timer = $Timer
var seconds_left : int = 3
signal countdown_finished


func _ready() -> void:
	label.text = str(seconds_left)


func _on_Timer_timeout() -> void:
	countdown()


func countdown() -> void:
	seconds_left -= 1
	if seconds_left < 0:
		label.hide()
		emit_signal("countdown_finished")
	elif seconds_left == 0:
		label.text = "GO!"
		timer.start()
	else:
		label.text = str(seconds_left)
		timer.start()
