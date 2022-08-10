extends CanvasLayer

export(Resource) var player_owned_resources = player_owned_resources as PlayerOwnedResources

onready var vbox = $VBox
onready var caught_fish_qty = vbox.get_node("FishQty")
onready var wood_qty = vbox.get_node("WoodQty")
onready var steel_qty = vbox.get_node("SteelQty")
onready var bricks_qty = vbox.get_node("BricksQty")

func _ready() -> void:
	update_resource_qty_labels()

func update_resource_qty_labels() -> void:
	caught_fish_qty.text = "Fish: %d" % player_owned_resources.qty_of_caught_fish_owned
	wood_qty.text = "Wood: %d" % player_owned_resources.qty_of_wood_owned
	steel_qty.text = "Steel: %d" % player_owned_resources.qty_of_steel_owned
	bricks_qty.text = "Bricks: %d" % player_owned_resources.qty_of_bricks_owned
