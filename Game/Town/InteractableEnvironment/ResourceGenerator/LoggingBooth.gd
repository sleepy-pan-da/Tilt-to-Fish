#extends "res://Game/Town/InteractableEnvironment/ResourceGenerator/ResourceGeneratorTemplate.gd"
extends ResourceGenerator

func player_has_necessary_requirements_to_generate_resource() -> bool:
	return player_owned_resources.have_enough_fish(specs.qty_of_caught_fish_required[level])

func perform_transaction_on_player_owned_resources() -> void:
	player_owned_resources.qty_of_caught_fish_owned -= specs.qty_of_caught_fish_required[level]
	player_owned_resources.qty_of_wood_owned += specs.qty_of_resource_generated[level]
	GameEvents.emit_signal("updated_player_owned_resources")
