extends CanvasLayer

onready var color_rect = $ColorRect
onready var label = $Label

var down = []

func _input(event) -> void:
	if event is InputEventScreenTouch:
		if !event.pressed:
			down.erase(event.index)
		elif is_in_rect(event.position, color_rect.get_rect()):
			down.append(event.index)
		label.text = str(down.size())

func is_in_rect(current_position : Vector2, rect : Rect2) -> bool:
	return current_position.x > rect.position.x \
		and current_position.x < rect.end.x \
		and current_position.y > rect.position.y \
		and current_position.y < rect.end.y
		
