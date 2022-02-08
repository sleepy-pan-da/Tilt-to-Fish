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
export(bool) var spawns_orbs

export(String) var name
export(int) var buying_cost
export(Array, int) var selling_cost 
export(String, MULTILINE) var description

enum RARITY_TYPES {COMMON, UNCOMMON, RARE}
export(RARITY_TYPES) var rarity
