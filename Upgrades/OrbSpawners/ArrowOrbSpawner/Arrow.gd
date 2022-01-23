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
	print("Sup boiii")


func set_bobber_reference(bobber_reference : Bobber) -> void:
	bobber = bobber_reference


func fire() -> void:
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
	if animation_player.current_animation == "Charging":
		var direction : Vector2 = bobber.arrow.compute_arrow_direction()
		rotate(direction.angle() - rotation)
	translate(velocity * delta)
	

func set_value(new_damage_value : float) -> void:
	damage = new_damage_value


func on_screen_exited() -> void:
	print("arrow left the screen")
	queue_free()


func get_name() -> String:
	return "Arrow"
