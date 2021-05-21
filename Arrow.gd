extends Sprite


var path_radius : int 
var initial_vector : Vector2
const INITIAL_ROTATION : float = PI/2

func _ready() -> void:
	path_radius = position.x
	#configure_arrow_location(Vector2.LEFT)
	pass
	
	
func configure_arrow_location(velocity : Vector2) -> void:
	var angle_wrt_x_axis : float = velocity.angle() 
	var angle_to_rotate_arrow_by : float = angle_wrt_x_axis - (rotation - INITIAL_ROTATION)
	
	if initial_vector == null:
		initial_vector = velocity
	var significant_diff_in_angle : bool = abs(rad2deg(velocity.angle_to(initial_vector))) >= 15
		
		
	

	if significant_diff_in_angle and velocity.length() >= 125:
		position.x = path_radius * cos(angle_wrt_x_axis)
		position.y = path_radius * sin(angle_wrt_x_axis)
		initial_vector = velocity
		rotate(angle_to_rotate_arrow_by)

