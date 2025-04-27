extends Control

func _unhandled_key_input(event: InputEvent) -> void:
	print("ijjijij")
	if event is InputEventKey and event.pressed:
		get_tree().change_scene_to("res://scenes/level_1.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
