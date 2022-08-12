extends InteractableEnvironment

class_name ResourceGenerator

export(Resource) var player_owned_resources = player_owned_resources as PlayerOwnedResources
export(Resource) var specs = specs as ResourceGeneratorSpecs

var level : int = 0 # this is hardcoded for now

func interact_with_player() -> void:
	if player_has_necessary_requirements_to_generate_resource():
		perform_transaction_on_player_owned_resources()

# to be overriden
func player_has_necessary_requirements_to_generate_resource() -> bool:
	return true

# to be overriden
func perform_transaction_on_player_owned_resources() -> void:
	pass
