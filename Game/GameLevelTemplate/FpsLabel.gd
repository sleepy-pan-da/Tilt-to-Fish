extends Label


func _physics_process(delta) -> void:
	update()


func update() -> void:
	text = "FPS: " + str(Engine.get_frames_per_second())
