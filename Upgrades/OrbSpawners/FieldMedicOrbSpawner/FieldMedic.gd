extends Area2D

export(Resource) var bobber_stats = bobber_stats as BobberStats

onready var animation_player = $AnimationPlayer
onready var progress_bar = $ProgressBar
onready var check_if_anything_is_inside = $CheckIfAnythingIsInside
var is_occupied : bool = false

func _ready() -> void:
	progress_bar.connect("progress_bar_filled", self, "on_progress_bar_filled")
	animation_player.play("SetUp")


func on_progress_bar_filled() -> void:
	bobber_stats.gain_hook(1)
	progress_bar.reset()


func set_incremented_values(new_incremented_values) -> void:
	progress_bar.set_amount_needed_to_fill(new_incremented_values[0])
	#print("Amount needed to fill FieldMedic is " + str(progress_bar.max_value))


func _on_LifeSpan_timeout():
	animation_player.play("Collapse")


func _on_CheckIfAnythingIsInside_timeout():
	if is_occupied:
		progress_bar.increment()
	else:
		progress_bar.decrement()
#	if !get_overlapping_bodies().empty():
#		check_if_anything_is_inside.start()


func _on_FieldMedic_body_entered(body):
	is_occupied = true


func _on_FieldMedic_body_exited(body):
	is_occupied = false
