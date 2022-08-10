extends Control

onready var analog_stick_area = $AnalogStickArea
onready var analog_stick = $AnalogStick

var analog_stick_center_position : Vector2
var analog_stick_radius : float
var touching_analog_stick : bool = false
var touching_analog_stick_index : int = -1

signal computed_move_vector_from_analog_stick

# The analog stick will not work if the screen size is changed midgame
# as the below code only calls in ready
func _ready() -> void:
	analog_stick_radius = analog_stick_area.shape.radius * analog_stick_area.scale.x
	analog_stick_center_position = analog_stick_area.global_position + Vector2(analog_stick_radius, analog_stick_radius)

func _physics_process(delta):
	var move_vector : Vector2 = analog_stick.global_position - analog_stick_center_position
	emit_signal("computed_move_vector_from_analog_stick", move_vector)
	
func _input(event):
	if !touching_analog_stick: 
		return

	# calls when you press and release from screen
	# does not call when you hold
	if event is InputEventScreenTouch: 
		if touching_analog_stick_index == -1:
			touching_analog_stick_index = event.index
		else:
			return # this is another touch screen input that should be ignored

	if event is InputEventScreenDrag:
		if !check_if_within_draggable_area(event.position):
			reset_analog_stick_state()
			return
	
	if event is InputEventScreenTouch or event is InputEventScreenDrag:	
		var move_vector_direction : Vector2 = calculate_move_vector_direction(event.position)
		if (event.position - analog_stick_center_position).length() > analog_stick_radius:
			analog_stick.global_position = analog_stick_center_position + (move_vector_direction * analog_stick_radius)
		else:
			analog_stick.global_position = event.position


# controls will be relocated with the analog stick at the center of the touch screen button
func relocate_controls_in_neutral_position(position_to_relocate_to) -> void:
	# The touch screen button's position is taking it's top left corner as reference
	analog_stick_area.position = position_to_relocate_to - Vector2(analog_stick_radius, analog_stick_radius) 
	analog_stick.position = position_to_relocate_to
	analog_stick_center_position = position_to_relocate_to

# allows dragging of touch screen button when analog stick exceeds radius
func relocate_controls(position_to_relocate_to) -> void:
	analog_stick_area.position = position_to_relocate_to - Vector2(analog_stick_radius, analog_stick_radius)
	analog_stick_center_position = position_to_relocate_to	

func calculate_move_vector_direction(event_position : Vector2) -> Vector2:
	return (event_position - analog_stick_center_position).normalized()

func reset_analog_stick_state() -> void:
	touching_analog_stick = false
	touching_analog_stick_index = -1
	analog_stick.global_position = analog_stick_center_position

func check_if_within_draggable_area(current_position : Vector2) -> bool:
	var rect : Rect2 = get_rect()
	return current_position.x > rect.position.x \
		and current_position.x < rect.end.x \
		and current_position.y > rect.position.y \
		and current_position.y < rect.end.y

# entry point of _input()
func _on_AnalogStickArea_pressed() -> void:
	touching_analog_stick = true

func _on_AnalogStickArea_released() -> void:
	reset_analog_stick_state()
