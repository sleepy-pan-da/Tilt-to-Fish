extends Control

onready var button_label = $Button/PlayAgain
onready var tween = $Button/PlayAgain/Tween
onready var high_score = $HighScore
var released_button : bool = false
signal clicked_play_again

func _ready() -> void:
	update_high_score_label(RunManager.player_statistics.highest_round_reached)


func _on_Button_button_down() -> void:
	tween.interpolate_property(button_label, "rect_scale", Vector2(1,1), Vector2(0.9, 0.9), 0.1, Tween.TRANS_LINEAR)
	tween.start()


func _on_Button_button_up() -> void:
	released_button = true
	tween.interpolate_property(button_label, "rect_scale", Vector2(0.9,0.9), Vector2(1, 1), 0.1, Tween.TRANS_LINEAR)
	tween.start()
	SfxManager.ui.play("Confirm")

func _on_Tween_tween_all_completed() -> void:
	if released_button:
		released_button = false
		emit_signal("clicked_play_again")


func update_high_score_label(new_high_score) -> void:
	high_score.text = "Highest round reached: " + str(new_high_score)
