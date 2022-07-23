extends Node



func play(sfx_name : String, pitch_scale : float = 1.0) -> void:
	if !sfx_name: return
	var sfx : AudioStreamPlayer = get_node(sfx_name)
	sfx.pitch_scale = pitch_scale
	sfx.play()


func stop(sfx_name : String) -> void:
	if !sfx_name: return
	get_node(sfx_name).stop()
