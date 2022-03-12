extends Label


func update_item_description(item_description : String) -> void:
	text = item_description


func append_item_description(appended_text : String) -> void:
	text += appended_text
