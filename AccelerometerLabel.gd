extends Label



func _process(delta : float) -> void:
	var PhoneAccelerometer : Vector3
	PhoneAccelerometer = Input.get_accelerometer()
	PhoneAccelerometer.x = round(Input.get_accelerometer().x)
	PhoneAccelerometer.y = round(Input.get_accelerometer().y)
	PhoneAccelerometer.z = round(Input.get_accelerometer().z)
	text = "Accelerometer: " + str(PhoneAccelerometer)
