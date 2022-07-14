extends Resource

class_name Prophecy

export(String) var name = "Prophecy Name"
export(String) var requirements = "What do u need to do to fulfil"

# current_progress / amount_to_fulfil 
# current_progress must always be <= amount_to_fulfil
export(int) var current_progress = 0
export(int) var amount_to_fulfil = 1

export(Resource) var item_reward = item_reward as ItemTraits
export(bool) var is_fulfilled = false
