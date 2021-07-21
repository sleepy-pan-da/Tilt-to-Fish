extends Node2D

export(String, FILE, "*.tscn") var main_menu
#export(PackedScene) var main_menu
export(Resource) var control_config = control_config as ControlConfig
export(PackedScene) onready var current_bobber

onready var topdown_button = $UI/HoldingPreference/TopDownButton
onready var regular_button = $UI/HoldingPreference/RegularButton
onready var back_button = $UI/BackButton
onready var tilt_sensitivity = $UI/TiltSensitivity
onready var toggle_bobber_button = $UI/ToggleBobberButton
onready var screen_transition = $UI/ScreenTransition
onready var bobber_spawn_pt = $BobberSpawnPt

var bobber : Bobber

func _ready() -> void:
	screen_transition.transition_in()
	update_current_holding_preference()
	update_current_tilt_sensitivity()
	topdown_button.connect("clicked_topdown", self, "on_clicked_holding_preference_button")
	regular_button.connect("clicked_regular", self, "on_clicked_holding_preference_button")
	back_button.connect("clicked_back", self, "on_clicked_back")
	toggle_bobber_button.connect("clicked_toggle_bobber", self, "manage_bobber_instance")
	screen_transition.connect("transitioned_out", self, "go_back")

func update_current_holding_preference() -> void:
	hide_all_ticks()
	var current_holding_preference : String = control_config.holding_preference
	match current_holding_preference:
		"topdown":
			topdown_button.show_tick()
		"regular":
			regular_button.show_tick()


func hide_all_ticks() -> void:
	topdown_button.hide_tick()
	regular_button.hide_tick()


func update_current_tilt_sensitivity() -> void:
	tilt_sensitivity.set_slider_value(control_config.tilt_sensitivity)


func on_clicked_holding_preference_button(holding_preference : String) -> void:
	control_config.holding_preference = holding_preference
	update_current_holding_preference()


func on_clicked_back() -> void:
	if toggle_bobber_button.bobber_present:
		bobber.queue_free()
	screen_transition.transition_out()


func go_back() -> void: # this takes too long, need to optimise
	get_tree().change_scene(main_menu)


func _on_HSlider_value_changed(value) -> void:
	save_tilt_sensitivity()	


func save_tilt_sensitivity() -> void:
	control_config.tilt_sensitivity = tilt_sensitivity.get_slider_value()


func manage_bobber_instance(bobber_in_scene : bool) -> void:
	if bobber_in_scene:
		bobber.queue_free()
	else:
		create_bobber_instance()


func create_bobber_instance() -> void:
	bobber = current_bobber.instance()
	bobber.have_immunity = false
	add_child(bobber)
	bobber.global_position = bobber_spawn_pt.global_position