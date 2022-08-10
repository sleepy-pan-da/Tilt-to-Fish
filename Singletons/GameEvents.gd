extends Node

# Event bus for distant nodes to communicate using signals.
# This is intended for cases where connecting the nodes directly creates more coupling
# or increases code complexity substantially.

# Instead of manually connecting signals, this globalscript acts as an interface to manage and pass signals 
# between different scenes. A sample use case would be the fishes. As fishes are randomly spawned,
# it will be a hassle to connect their signals to GameLevelTemplate everytime a new fish is spawned.
# This globalscript therefore helps solve this problem.

signal bobber_took_damage(damage_taken) # need to pass damage taken to manage confidence
signal bobber_gained_hook(num_of_hook_gained) # connected to GameLevelTemplate.tscn and NewShop/UI.gd
signal need_to_recompute_bobber_hooks_and_max_hooks(to_reset_max_hooks) # connected to NewShop/UI.gd
signal successfully_caught_fish (fish_position, fish_name) # need to pass fish_position to manage intimidation

signal bobber_touched_orb(name_of_orb_last_touched) # connected to GameLevelTemplate/OrbManager.gd, this manages the spawning of next orb

signal triggered_orb_that_requires_bobber(item_name, incremented_values) # connected to Bobber.tscn
signal set_up_bobber_item_at_start_of_fishing(item_name, incremented_values) # connected to Bobber.tscn
signal set_up_bobber_proximity_area_timers_at_start_of_fishing(item_name, incremented_values) # connected to Bobber.tscn

signal triggered_item_on_caught_fish(item_name, incremented_values) # connected to GameLevelTemplate.tscn
signal triggered_item_that_requires_bobber(item_name, incremented_values) # connected to Bobber.tscn
signal set_up_orb_spawner_at_start_of_fishing(item_name, incremented_values) # connected to GameLevelTemplate.tscn

signal detonated_charges() # connected to tnt's attachedcharge.tscn

signal pressed_fish_button_in_index(fish_name) # connected to FishIndex/Body.gd

signal to_restart_game_from_paused_screen() # connected to GameLevelTemplate.tscn
signal to_quit_game_from_paused_screen() # connected to GameLevelTemplate.tscn

# Town --------------------------------------------------------------

signal closed_interactable_pop_up() # connected to PlayerCharacter.tscn
