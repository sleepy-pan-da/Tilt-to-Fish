extends Resource

class_name Hat

export(String) var name = "Hat Name"
export(String) var description = "What does it do"

# cost to unlock
export(int) var qty_of_caught_fish_required = 0
export(int) var qty_of_wood_required = 0
export(int) var qty_of_steel_required = 0
export(int) var qty_of_bricks_required = 0

export(bool) var unlocked = false
