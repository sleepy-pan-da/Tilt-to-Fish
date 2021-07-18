extends Control

onready var damage_multiplier = $DamageMultiplier
onready var fill_amount = $FillAmount
onready var orb_damage_alpha = $OrbDamageAlpha
onready var orb_damage_gamma = $OrbDamageGamma
onready var poke_damage = $PokeDamage
onready var pull_out_damage = $PullOutDamage

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
		if bobber.bobber_stats.can_poke:
			poke_damage.text = "Poke damage: " + str(bobber.bobber_stats.poke_damage)
		else:
			poke_damage.text = "Poke damage: " 
		if bobber.bobber_stats.can_pull_out:
			pull_out_damage.text = "Pull out damage: " + str(bobber.bobber_stats.pull_out_damage)
		else:
			pull_out_damage.text = "Pull out damage: " 
