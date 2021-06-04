extends Label



func _process(delta : float) -> void:
	var PhoneAccelerometer : Vector2
	PhoneAccelerometer.x = round(Input.get_accelerometer().x)
	PhoneAccelerometer.y = round(Input.get_accelerometer().y)
	text = "Accelerometer: " + str(PhoneAccelerometer)
