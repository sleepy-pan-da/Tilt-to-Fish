extends VBoxContainer

onready var prophecy_name = $Name
onready var requirements = $Requirements

func update_contents(prophecy : Prophecy) -> void:
	if prophecy == null:
		prophecy_name.text = "prophecy name"
		requirements.text = "requirements"
	else:
		prophecy_name.text = prophecy.name
		requirements.text = prophecy.requirements
