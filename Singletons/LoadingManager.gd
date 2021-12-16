extends Node2D

# As of now, loads everything upon launch. Reduces waiting when transitioning scenes in exchange for longer
# waiting time at startup.

export(PackedScene) var main_menu
export(PackedScene) var options
export(PackedScene) var wave_level
export(PackedScene) var shop
