extends Node2D

onready var b = $B
onready var c = $B/C

func _ready():
	reparent(c, self)
	reparent(b, $C)

func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)
