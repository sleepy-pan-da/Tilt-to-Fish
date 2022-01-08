extends Control

onready var content = $Content

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_T:
			if event.shift:
				visible = !visible

func populate_content(current_bobber_stats : BobberStats) -> void:
	content.get_node("ReelDamage").text = "Reel Damage: " + str(current_bobber_stats.reel_damage)
	content.get_node("ReelRate").text = "Reel Rate: " + str(current_bobber_stats.reel_attack_rate)
		
