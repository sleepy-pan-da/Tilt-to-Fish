extends Resource
class_name ItemTraits

# Parameters that make up the item
# Helps in identifying when to trigger the item
# e.g. item that modifies_stats_at_start_of_fishing will be triggered at start of fishing
export(bool) var modifies_stats_at_start_of_fishing
export(bool) var overrides_stats_at_start_of_fishing
export(bool) var spawns_orbs

export(int) var cost 
export(String) var description
enum RARITY_TYPES {COMMON, UNCOMMON, RARE}
export(RARITY_TYPES) var rarity
