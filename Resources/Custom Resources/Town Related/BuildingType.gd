extends Resource

class_name BuildingType
# Resources required for construction
export(int) var qty_of_caught_fish_required = 0
export(int) var qty_of_wood_required = 0
export(int) var qty_of_steel_required = 0
export(int) var qty_of_bricks_required = 0
export(bool) var is_built = false
export(PackedScene) var scene
