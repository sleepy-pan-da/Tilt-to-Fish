extends InteractableEnvironment
 
onready var building_popup = $BuildingPopUpTemplate

func interact_with_player() -> void: 
	show_popup()

func show_popup() -> void:
	building_popup.toggle_popup_visibility(true)

func hide_popup() -> void:
	building_popup.toggle_popup_visibility(false)
