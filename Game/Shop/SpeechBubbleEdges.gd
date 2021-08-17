extends Control


func update_bubble_edges(index_of_bubble_edge_to_show : int) -> void:
	hide_all_bubble_edges()
	get_child(index_of_bubble_edge_to_show).show()


func hide_all_bubble_edges() -> void:
	for i in range(get_child_count()):
		get_child(i).hide()
