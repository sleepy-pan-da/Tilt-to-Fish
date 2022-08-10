extends CanvasLayer

onready var analog_stick_controls = $AnalogStickControls
onready var right_side_controls = $RightSideControls

export(bool) var right_side_controls_is_visible = true

func _ready() -> void:
	right_side_controls.toggle_visibility(right_side_controls_is_visible)

func toggle_visibility(is_visible : bool) -> void:
	for child in get_children():
		child.visible = is_visible
