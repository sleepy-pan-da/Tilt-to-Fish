extends KinematicBody2D

onready var sprite = $Sprite
onready var analog_stick = $AnalogStickLayer
onready var state_machine_label = $StateMachineLabel

const MAX_SPEED = 400
const ACCELERATION := 16000
var current_velocity : Vector2

func _ready() -> void:
		analog_stick.connect("computed_move_vector_from_analog_stick", self, "move_with_analog_stick")

func move_with_analog_stick(analog_stick_move_vector : Vector2) -> void:
	var movement_direction : Vector2 
	var speed_multiplier : int = 4 # This number is determined by the MAX_SPEED / radius of analog stick circle. There's hard coupling here but I guess this will do for now
	var desired_velocity : Vector2
	
	update_state_machine_label(analog_stick_move_vector)
	desired_velocity =  Vector2(analog_stick_move_vector.x, analog_stick_move_vector.y)
	desired_velocity *= speed_multiplier

	if desired_velocity.length() > MAX_SPEED:
		desired_velocity = desired_velocity.normalized() * MAX_SPEED
	current_velocity = current_velocity.move_toward(desired_velocity, ACCELERATION * get_physics_process_delta_time())
	#print(current_velocity)
	move_and_slide(current_velocity)

func update_state_machine_label(movement_direction : Vector2) -> void:
	movement_direction = movement_direction.normalized()
	if movement_direction.x != 0:
		sprite.animation = "Walk Horizontal"
		sprite.flip_h = movement_direction.x < 0

#	if abs(movement_direction.x) > abs(movement_direction.y): # horizontal animation
#		if movement_direction.x > 0:
#			state_machine_label.text = "Right"
#		elif movement_direction.x < 0:
#			state_machine_label.text = "Left"
#	elif abs(movement_direction.x) < abs(movement_direction.y): # vertical animation
#		if movement_direction.y > 0:
#			state_machine_label.text = "Down"
#		elif movement_direction.y < 0:
#			state_machine_label.text = "Up"
	else:
		sprite.animation = "Idle"
		state_machine_label.text = "Idle"
