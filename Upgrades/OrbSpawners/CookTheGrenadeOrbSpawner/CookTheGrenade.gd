extends Area2D

export(PackedScene) onready var explosion
export(PackedScene) onready var passed_grenade
onready var animation_player = $AnimationPlayer

var damage : float
var max_damage : float
var can_pass_to_fish : bool = false

func _ready():
	animation_player.play("Cooking")


func set_incremented_values(new_incremented_values) -> void:
	max_damage = new_incremented_values[0]

# grenade can only be passed after a while of holding
# prevents the scenario where u pick up the grenade in the fish's proximity area
# and got forced to pass it to that fish
func make_grenade_ready_to_be_passed() -> void: 
	can_pass_to_fish = true


func explode() -> void:
	var triggered_instance = explosion.instance()
	get_parent().get_parent().add_child(triggered_instance)
	triggered_instance.set_damage(max_damage)
	triggered_instance.global_position = global_position
	#print("accumulated_damage: " + str(triggered_instance.damage))
	queue_free()

# entered a proximity area
func _on_CookTheGrenade_area_entered(area):
	if can_pass_to_fish:
		pass_to_fish(area)


func pass_to_fish(area) -> void:
	var passed_grenade_instance = passed_grenade.instance()
	area.get_parent().add_child(passed_grenade_instance)
	passed_grenade_instance.global_position = area.get_parent().global_position
	damage = compute_accumulated_damage(animation_player.current_animation_position)
	passed_grenade_instance.on_passed(damage, animation_player.current_animation_position)
	queue_free()


func compute_accumulated_damage(time_spent_cooking : float) -> float:
	var total_time : float = animation_player.current_animation_length
	var accumulated_damage : float = (time_spent_cooking / total_time) * max_damage
	return accumulated_damage
