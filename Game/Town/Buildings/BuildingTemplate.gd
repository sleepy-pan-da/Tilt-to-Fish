extends StaticBody2D

onready var building_popup = $BuildingPopUpTemplate

func toggle_popup_visibility(is_visible : bool) -> void:
	building_popup.toggle_popup_visibility(is_visible)
