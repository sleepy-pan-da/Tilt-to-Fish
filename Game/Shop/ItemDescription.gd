extends RichTextLabel


func update_item_description(item_description : String, item_level : int) -> void:
	var updated_item_description : String = get_highlighted_item_description(item_description, item_level)
	bbcode_text = updated_item_description

# Items usually have values pertaining to them. (e.g. +15/20/30 damage)
# Based on the item level, this highlights the current value pertaining to the item.
# (e.g. If item level = 2, 20 will be highlighted in the above e.g.) 
# This informs the player of their item's current stat.
func get_highlighted_item_description(item_description : String, item_level : int) -> String:
	var lines = item_description.split("\n")
	for i in range(len(lines)):
		if "/" in lines[i]: # possible to have substring like 15/20/30
			var substrings = lines[i].split(" ")
			for substring_index in range(len(substrings)):
				var substring : String = substrings[substring_index]
				if substring.count("/") == 2: # finding for substring like 15/20/30 to highlight
					var item_values_pertaining_to_lvl = substring.split("/")
					item_values_pertaining_to_lvl[item_level - 1] = "[color=green]" + item_values_pertaining_to_lvl[item_level - 1] + "[/color]"
					
					# put the reformed substring parts back together
					substring = ""
					for index in range(len(item_values_pertaining_to_lvl)):
						substring += item_values_pertaining_to_lvl[index]
						if index < len(item_values_pertaining_to_lvl) - 1:
							substring += "/"
					substrings[substring_index] = substring
			
			# put the substrings back together into the line
			var highlighted_line : String
			for index in range(len(substrings)):
				highlighted_line += substrings[index]
				if index < len(substrings) - 1:
					highlighted_line += " "
			lines[i] = highlighted_line
	
	# put the lines back together
	var highlighted_item_description : String
	for index in range(len(lines)):
		highlighted_item_description += lines[index]
		if index < len(lines) - 1:
			highlighted_item_description += "\n"
	return highlighted_item_description
