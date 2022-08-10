extends Control

onready var popup = $CanvasLayer/Popup

func toggle_popup_visibility(is_visible : bool) -> void:
	popup.visible = is_visible
