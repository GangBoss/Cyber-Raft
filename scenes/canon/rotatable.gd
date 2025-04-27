extends Node3D
class_name Rotatable

var target_position: Vector3  # The 3D position to rotate towards
var rotation_speed: float = 3.14  # Speed of rotation in radians per second
var is_rotating: bool = false
var current_target_angle_y: float # Keep track of the target angle
var rotation_threshold: float = 0.1 # Threshold to stop rotation, in radians

func start_rotation(target: Vector3):
	target_position = target
	is_rotating = true
	# Calculate the target angle only once when rotation starts
	current_target_angle_y = _calculate_target_angle_y()

func _calculate_target_angle_y() -> float:
	var direction_to_target: Vector3 = (target_position - global_position).normalized()
	return atan2(direction_to_target.x, direction_to_target.z)

func _process(delta: float):
	if is_rotating:
		# Get the object's current Y rotation
		var current_angle_y: float = rotation.y

		# Calculate the shortest rotation direction
		var delta_angle: float = current_target_angle_y - current_angle_y
		delta_angle = wrapf(delta_angle, -PI, PI) # Ensure the rotation is the shortest path (avoid spinning > 180 degrees)

		# Calculate the rotation amount for this frame
		var rotate_amount: float = rotation_speed * delta

		# Clamp the rotation amount to not overshoot
		if abs(delta_angle) < rotate_amount:
			rotate_amount = delta_angle
			is_rotating = false  # Stop rotating when close enough
		elif delta_angle > 0:
			rotate_amount = min(rotate_amount, delta_angle) #important
		else:
			rotate_amount = max(-rotate_amount, delta_angle) #important

		# Apply the rotation
		rotation.y += rotate_amount

		if not is_rotating:
			rotation.y = current_target_angle_y #ensure we end at the target
			print("Rotation finished. Target Y Rotation",current_target_angle_y,"Current Y Rotation",rotation.y)
