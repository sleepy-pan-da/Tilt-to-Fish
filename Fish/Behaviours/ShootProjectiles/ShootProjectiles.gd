extends Node2D

# how to use this node
# attach this inside kinematic body of fish

export(PackedScene) var projectile_to_shoot
export(float) var speed
var radius : int = 50
signal fired_projectile(projectile)

func fire(bobber_position : Vector2) -> void:
	var projectile : Projectile = projectile_to_shoot.instance()
	add_child(projectile)
	projectile.global_position = global_position # global position of fish
	var direction : Vector2 = (bobber_position - projectile.global_position).normalized()
	projectile.global_position = compute_projectile_initial_position(direction)
	projectile.velocity = direction * speed
	emit_signal("fired_projectile", projectile)


func compute_projectile_initial_position(direction : Vector2) -> Vector2:
	# all possible positions will result in a circle around the fish
	return global_position + direction * radius
