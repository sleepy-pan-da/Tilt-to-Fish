extends Node



func play(sfx_name : String) -> void:
	if !sfx_name: return
	get_node(sfx_name).play()


func stop(sfx_name : String) -> void:
	if !sfx_name: return
	get_node(sfx_name).stop()
