extends Node

# Event bus for distant nodes to communicate using signals.
# This is intended for cases where connecting the nodes directly creates more coupling
# or increases code complexity substantially.

# Instead of manually connecting signals, this globalscript acts as an interface to manage and pass signals 
# between different scenes. A sample use case would be the fishes. As fishes are randomly spawned,
# it will be a hassle to connect their signals to GameLevelTemplate everytime a new fish is spawned.
# This globalscript therefore helps solve this problem.

signal bobber_took_damage(damage_taken) # need to pass damage taken to manage confidence
signal bobber_gained_hook(num_of_hook_gained) # need to pass num_of_hook_gained to manage confidence
signal successfully_caught_fish (fish_position) # need to pass fish_position to manage intimidation

signal triggered_item_on_caught_fish(item_name, incremented_values)
