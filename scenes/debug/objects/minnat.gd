extends Sprite3D

const DEFAULT_STEP_TIME = 0.09
var step_time: float = DEFAULT_STEP_TIME
var step_side: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _is_moving() -> bool:
	#if stuck:
		#return false
	const move_array = ["ui_up", "ui_down", "ui_left", "ui_right"]
	for move in move_array:
		if Input.is_action_pressed(move):
			return true
	return false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	step_time -= delta
	if step_time < 0:
		step_time = DEFAULT_STEP_TIME
		step_side = (step_side + 1) % 2
		if _is_moving():
			rotation.z = randf_range(-0.08, 0) if step_side else randf_range(0, 0.08)
