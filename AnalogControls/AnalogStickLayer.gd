extends CanvasLayer

onready var touch_screen_button = $TouchScreenButton
onready var analog_stick = $AnalogStick

var analog_stick_center_position : Vector2
var analog_stick_radius : float
var just_pressed_screen : bool = false
var move_vector : Vector2

signal computed_move_vector_from_analog_stick

func _ready() -> void:
	analog_stick_radius = touch_screen_button.shape.radius * touch_screen_button.scale.x
	analog_stick_center_position = touch_screen_button.position + Vector2(analog_stick_radius, analog_stick_radius)
	set_visibility_of_controls(false)

func _physics_process(delta):
	var move_vector : Vector2
	if controls_is_visible():
		move_vector = analog_stick.position - analog_stick_center_position
	else:
		move_vector = Vector2.ZERO
	emit_signal("computed_move_vector_from_analog_stick", move_vector)
	
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			relocate_controls(event.position)
			set_visibility_of_controls(true)
		else:
			set_visibility_of_controls(false)
			
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		var move_vector_direction : Vector2 = calculate_move_vector_direction(event.position)
		if (event.position - analog_stick_center_position).length() > analog_stick_radius:
			analog_stick.position = analog_stick_center_position + move_vector_direction * analog_stick_radius
		else:
			analog_stick.position = event.position
			
#	if controls_is_visible():
#		move_vector = analog_stick.position - analog_stick_center_position
#		print(move_vector)
#	else:
#		move_vector = Vector2.ZERO
#		print(move_vector)
#	emit_signal("computed_move_vector_from_analog_stick", move_vector)

func relocate_controls(position_to_relocate_to) -> void:
	touch_screen_button.position = position_to_relocate_to - Vector2(analog_stick_radius, analog_stick_radius)
	analog_stick.position = position_to_relocate_to
	analog_stick_center_position = position_to_relocate_to

func calculate_move_vector_direction(event_position : Vector2) -> Vector2:
	return (event_position - analog_stick_center_position).normalized()

func set_visibility_of_controls(is_visible : bool) -> void:
	if is_visible:
		touch_screen_button.modulate.a8 = 100
		analog_stick.modulate.a = 1
	else:
		touch_screen_button.modulate.a8 = 0
		analog_stick.modulate.a = 0


func controls_is_visible() -> bool:
	return analog_stick.modulate.a == 1
