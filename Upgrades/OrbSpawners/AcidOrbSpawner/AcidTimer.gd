extends Timer

onready var lifespan_timer = $LifespanTimer

export(PackedScene) var acid

var damage : float 
var spawn_time : float = 0.1
var life_span : float = 5

func _ready() -> void:
	wait_time = spawn_time
	lifespan_timer.wait_time = life_span
	start()
	lifespan_timer.start()


func _on_AcidTimer_timeout():
	var triggered_instance = acid.instance()
	triggered_instance.set_value(damage)
	triggered_instance.global_position = get_parent().global_position
	get_parent().get_parent().add_child(triggered_instance)


func set_incremented_values(incremented_values) -> void:
	damage = incremented_values[0]


func _on_LifespanTimer_timeout():
	queue_free()
