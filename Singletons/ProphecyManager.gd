extends Node2D

export(Resource) var prophecies_to_fulfil = prophecies_to_fulfil as PropheciesToFulfil

func updates_prophecies_when_caught_fish() -> void:
	for prophecy in prophecies_to_fulfil.prophecies:
		if prophecy.is_fulfilled: 
			continue
		if prophecy.updates_when_caught_fish:
			match prophecy.name:
				"Rookie Angler":
					prophecy.current_progress += 1
			if prophecy.is_fulfilled:
				UiOverlay.add_to_popup_queue(prophecy)
