extends Area2D

class_name ThrillSeeker

signal activated_thrill_seeker

func get_class() -> String:
	return "ThrillSeeker"


func _on_ThrillSeeker_area_entered(area):
	emit_signal("activated_thrill_seeker")
