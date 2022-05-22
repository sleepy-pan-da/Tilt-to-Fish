extends "res://Singletons/SFXManager/UI.gd"

var grenades_on_fuse : int = 0 setget set_grenades_on_fuse

func set_grenades_on_fuse(new_value : int) -> void:
	grenades_on_fuse = new_value
	if grenades_on_fuse < 0: 
		grenades_on_fuse = 0
