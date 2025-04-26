extends Area2D


@onready var timer: Timer = $Timer
signal you_died


func _on_body_entered(body: Node2D) -> void:
	Engine.time_scale = 0.5
	you_died.emit(name)
	body.get_node("CollisionShape2D").queue_free()
	print("RIP") # Replace with function body.
	timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
