extends Sprite

onready var tween = $Tween
var path_radius : int 
var initial_velocity : Vector2 = Vector2.ZERO
var configuring_position : bool = false

func _ready() -> void:
	path_radius = position.x
	
	
func configure_arrow_location(velocity : Vector2) -> void:
	var velocity_angle_wrt_x_axis : float = velocity.angle() 
	
	if initial_velocity == Vector2.ZERO:
		initial_velocity = velocity

	var significant_angle_diff : bool = abs(rad2deg(velocity.angle_to(initial_velocity))) >= 5
	if significant_angle_diff and velocity.length() >= 175 and !configuring_position:
		configuring_position = true
		var diff_in_angle : float = abs(position.angle() - velocity_angle_wrt_x_axis)
		
		if diff_in_angle > PI: # arrow will pick smallest angle of rotation
			# change direction for arrow movement
			if sign(velocity_angle_wrt_x_axis) == 1: 
				velocity_angle_wrt_x_axis -= 2*PI
			else:
				velocity_angle_wrt_x_axis += 2*PI
		
		tween.interpolate_method(self, "compute_arrow_position", 
		position.angle(), 
		velocity_angle_wrt_x_axis, 
		0.12, Tween.TRANS_SINE, Tween.EASE_OUT_IN)
		
		tween.start()
		initial_velocity = velocity
		

func compute_arrow_position(angle_wrt_x_axis : float):
	position.x = path_radius * cos(angle_wrt_x_axis)
	position.y = path_radius * sin(angle_wrt_x_axis)
	rotate(angle_wrt_x_axis - rotation)
	

func _on_Tween_tween_completed(_object, _key):
	configuring_position = false


func compute_arrow_direction() -> Vector2:
	return position.normalized()
