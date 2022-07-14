extends Resource

class_name FishingGearUpgrade

export(String) var name = "Fishing gear name"
export(String) var description = "What upgrading this entails"

# times_upgraded / total_times_allowed_to_upgrade 
# times_upgraded must always be <= total_times_allowed_to_upgrade
export(int) var times_upgraded = 0
export(int) var total_times_allowed_to_upgrade = 1

# cost to unlock
export(int) var qty_of_caught_fish_required = 0
export(int) var qty_of_wood_required = 0
export(int) var qty_of_steel_required = 0
export(int) var qty_of_bricks_required = 0
