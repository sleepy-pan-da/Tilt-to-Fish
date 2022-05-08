extends Area2D

onready var animation_player = $AnimationPlayer
onready var follow_lifespan = $FollowLifespan

export(int) var speed : float

var damage : float
var stun_duration : float
var is_triggered : bool = false
var bobber_reference : Bobber

func _ready():
	animation_player.play("SetUp")


func on_finished_set_up() -> void:
	monitoring = true


func set_incremented_values(new_incremented_values) -> void:
	damage = new_incremented_values[0]
	stun_duration = new_incremented_values[2]
	#print("Mjolnir's damage is " + str(damage))


func _on_Mjolnir_body_entered(body : Bobber):
	if !is_triggered:
		is_triggered = true
		bobber_reference = body
		animation_player.play("Triggered")	


func on_finished_triggered() -> void:
	monitorable = true
	#follow_lifespan.start()


func compute_vector_to_move_towards_bobber(bobber : Bobber) -> Vector2:
	var velocity : Vector2 = Vector2.ZERO
	if bobber != null:
		var bobber_position : Vector2 = bobber.global_position
		var mjolner_to_bobber : Vector2 = bobber_position - global_position
		
		var far_from_bobber = mjolner_to_bobber.length() > 20
		if far_from_bobber:
			var direction_to_bobber : Vector2 = mjolner_to_bobber.normalized()
			velocity = direction_to_bobber * speed
		else:
			queue_free()
	else:
		queue_free() # for scenarios where bobber is no longer in the screen
	return velocity
		

func _physics_process(delta):
	if monitorable:
		rotate(PI * delta)
		var vector_to_move : Vector2 = compute_vector_to_move_towards_bobber(bobber_reference)
		global_position += vector_to_move * delta
	#fish.collision = fish.kinematic_body.move_and_collide(fish.movement_vector * _delta)


func get_name() -> String:
	return "Mjolnir"


func _on_FollowLifespan_timeout():
	queue_free()



