extends Control

onready var popup = $CanvasLayer/Popup

func toggle_popup_visibility(is_visible : bool) -> void:
	popup.visible = is_visible

func _on_Button_pressed() -> void:
	toggle_popup_visibility(false)
	GameEvents.emit_signal("closed_interactable_pop_up")
