extends Rotatable
class_name CanonBase

signal shooted
## Exports - Assign these in the Godot Editor Inspector
# The scene for the projectile (must be a RigidBody3D).
@export var projectile_scene: PackedScene
# The desired time in seconds for the projectile to stay in the air (approximately).
@export var air_time: float = 2.5
# The initial upward velocity multiplier. Adjust to control the height.
@export var upward_force_multiplier: float = 10.0
# Adjust this to control the influence of click distance on horizontal speed.
@export var horizontal_speed_factor: float = 2.0
# Store gravity vector (magnitude)
var gravity_magnitude: float
# Store the starting position of the launch
var launch_position: Vector3


var is_shooting: bool = false

func shoot(shoot_position: Vector3):
	is_shooting=true
	start_rotation(shoot_position)

func _process(delta: float):
	super(delta)
	if is_rotating == false && is_shooting == true:
		launch(target_position)

# Function to calculate the required initial vertical velocity to achieve air time
func calculate_initial_vertical_velocity(time: float) -> float:
	return gravity_magnitude * (time / 2.0) * upward_force_multiplier


# Function to calculate the horizontal velocity based on the mouse click and distance
func calculate_horizontal_velocity(click_position: Vector3) -> Vector3:
	var horizontal_displacement: Vector3 = click_position - launch_position
	horizontal_displacement.y = 0.0 # Only consider horizontal displacement
	var horizontal_distance: float = horizontal_displacement.length()

	if horizontal_distance > 0 and air_time > 0:
		var required_horizontal_speed: float = horizontal_distance / air_time * horizontal_speed_factor
		return horizontal_displacement.normalized() * required_horizontal_speed
	else:
		return Vector3.ZERO


# Function to instantiate and launch the projectile
func launch(target_position: Vector3):
	if projectile_scene == null:
		printerr("Projectile scene not assigned.")
		return

	var initial_vertical_velocity: float = calculate_initial_vertical_velocity(air_time)
	var initial_horizontal_velocity: Vector3 = calculate_horizontal_velocity(target_position)

	var initial_velocity: Vector3 = initial_horizontal_velocity
	initial_velocity.y = initial_vertical_velocity

	# Instance the projectile scene
	var projectile_instance = projectile_scene.instantiate()
	if not projectile_instance is RigidBody3D:
		printerr("Failed to instance projectile or root is not RigidBody3D.")
		if is_instance_valid(projectile_instance):
			projectile_instance.queue_free()
		return

	var projectile_rb: RigidBody3D = projectile_instance as RigidBody3D
	get_tree().root.add_child(projectile_rb)
	projectile_rb.global_position = launch_position
	projectile_rb.linear_velocity = initial_velocity
	is_shooting=false
	emit_signal("shooted")
	print("Projectile launched with velocity: ", initial_velocity)

# Set the initial launch position when the scene is ready
func _ready():
	launch_position = global_position
	gravity_magnitude = abs(ProjectSettings.get_setting("physics/3d/default_gravity_vector").y)
