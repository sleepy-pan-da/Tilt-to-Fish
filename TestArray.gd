extends Node2D

var my_array = ["Retaliate", 3]
func _ready():
	print(my_array)
	if my_array.has("Retaliate"):
		print("have")
	else:
		print("dont have")
