extends Node2D

export(Resource) var bobber_stats = bobber_stats as BobberStats

onready var progress_bar = $ProgressBar

func _ready() -> void:
	progress_bar.connect("progress_bar_filled", self, "on_progress_bar_filled")
	bobber_stats.multiply_damage_taken_multiplier(2)


func set_incremented_values(new_incremented_values) -> void:
	progress_bar.set_total_time_to_completion(new_incremented_values[0])
	#print("Amount needed to fill FieldMedic is " + str(progress_bar.max_value))


func _on_CheckEvery1s_timeout() -> void:
	progress_bar.increment()


func on_progress_bar_filled() -> void:
	SfxManager.bobber.long_rest.play("Full restore")
	var remaining_hooks : int = bobber_stats.max_hooks_amount - bobber_stats.hooks_amount
	if remaining_hooks > 0:
		bobber_stats.gain_hook(remaining_hooks)
	bobber_stats.multiply_damage_taken_multiplier(0.5)
	queue_free()
