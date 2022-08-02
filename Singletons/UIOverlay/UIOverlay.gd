extends Control

onready var popup_panel = $CanvasLayer/PopupPanel
export(Resource) var default_prophecy = default_prophecy as Prophecy

var popup_queue = []

func _ready() -> void:
	popup_panel.connect("popup_hide", self, "update_pop_up_text_and_show_from_front_of_popup_queue")

#func _process(delta) -> void:
#	if Input.is_action_just_pressed("ui_select"):
#		add_to_popup_queue(default_prophecy)

func add_to_popup_queue(prophecy : Prophecy) -> void:
	popup_queue.push_back(prophecy)
	if !popup_panel.visible:
		update_pop_up_text_and_show_from_front_of_popup_queue()
	#print("Current size of popup_queue: " + str(popup_queue.size()))
	
func update_pop_up_text_and_show_from_front_of_popup_queue() -> void:
	if popup_queue.empty(): return
	update_pop_up_text_and_show(popup_queue.pop_front())
	#print("Current size of popup_queue: " + str(popup_queue.size()))	

func update_pop_up_text_and_show(prophecy : Prophecy) -> void:
	popup_panel.show_up(prophecy)

