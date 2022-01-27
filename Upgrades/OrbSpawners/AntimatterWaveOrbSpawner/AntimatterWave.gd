extends Area2D

onready var animation_player = $AnimationPlayer
onready var visibility_notifier = $VisibilityNotifier2D

export(float) var speed

var damage : float
var velocity : Vector2 = Vector2(0, 0)
#var slow_multiplier : float = 1.0
var bobber : Bobber

func _ready():
	animation_player.play("Charging")


func set_bobber_reference(bobber_reference : Bobber) -> void:
	bobber = bobber_reference


func fire() -> void:
	if bobber:
		monitorable = true
		var direction : Vector2 = bobber.arrow.compute_arrow_direction()
		velocity = direction * speed
		var level = get_parent().get_parent()
		if level:
			var initial_global_position = global_position
			#print("old damage: " + String(damage))
			reparent(self, level)
			global_position = initial_global_position
			visibility_notifier.connect("screen_exited", self, "on_screen_exited")
			#print("new damage: " + String(damage))
		

func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)


func _physics_process(delta):
	if animation_player.current_animation == "Charging" and bobber:
		var direction : Vector2 = bobber.arrow.compute_arrow_direction()
		rotate(direction.angle() - rotation)
	translate(velocity * delta)
	

func set_incremented_values(new_incremented_values) -> void:
	damage = new_incremented_values[0]
	print("AntimatterWave damage is " + str(damage))


func on_screen_exited() -> void:
	queue_free()


func get_name() -> String:
	return "AntimatterWave"
