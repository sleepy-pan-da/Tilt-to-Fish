extends Control

onready var damage_multiplier = $DamageMultiplier
onready var fill_amount = $FillAmount
onready var orb_damage_alpha = $OrbDamageAlpha
onready var orb_damage_gamma = $OrbDamageGamma

func update_labels(bobber : Bobber) -> void:
	if bobber != null:
		damage_multiplier.text = "Dmg Multiplier: " + str(bobber.bobber_stats.damage_multiplier)
		fill_amount.text = "Fill Amount: " + str(bobber.bobber_stats.bobber_attack_amount) 
		if bobber.current_orbiting_orbs_alpha != null:
			orb_damage_alpha.text = "Orb Damage Alpha: " + str(bobber.current_orbiting_orbs_alpha.get_orb_damage())
		else:
			orb_damage_alpha.text = "Orb Damage Alpha: "
		if bobber.current_orbiting_orbs_gamma != null:
			orb_damage_gamma.text = "Orb Damage Gamma: " + str(bobber.current_orbiting_orbs_gamma.get_orb_damage())
		else:
			orb_damage_gamma.text = "Orb Damage Gamma: "

