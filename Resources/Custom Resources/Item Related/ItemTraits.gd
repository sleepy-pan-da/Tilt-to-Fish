extends Resource
class_name ItemTraits

# Parameters that make up the item
# Helps in identifying when to trigger the item
# e.g. item that modifies_stats_at_start_of_fishing will be triggered at start of fishing
export(bool) var modifies_stats_at_start_of_fishing
export(bool) var overrides_stats_at_start_of_fishing
export(bool) var set_up_bobber_item_at_start_of_fishing
export(bool) var triggers_when_lose_all_hooks
export(bool) var triggers_when_catch_fish
export(bool) var triggers_when_lose_hook
export(bool) var triggers_when_enter_proximity_area_of_stunned_fish
export(bool) var triggers_when_enter_proximity_area
export(bool) var triggers_when_bought
export(bool) var triggers_when_sold
export(bool) var triggers_when_bought_other_item
export(bool) var triggers_when_sold_other_item
export(bool) var triggers_when_visit_shop
export(bool) var spawns_orbs

export(String) var display_name
export(int) var buying_cost
export(Array, int) var selling_cost 
export(String, MULTILINE) var description

enum RARITY_TYPES {COMMON, UNCOMMON, RARE}
export(RARITY_TYPES) var rarity

export(Texture) var art

# if blueprint_unlocked and !unlocked: show item in temple as an unlockable
export(bool) var blueprint_unlocked
export(bool) var unlocked # some items are locked, can only be unlocked at the town

# cost to unlock
export(int) var qty_of_caught_fish_required = 0
export(int) var qty_of_wood_required = 0
export(int) var qty_of_steel_required = 0
export(int) var qty_of_bricks_required = 0
