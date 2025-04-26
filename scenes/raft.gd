extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var forward_speed: float = 2.5
var direction: Vector3

var box = preload("res://scenes/box.tscn")
@onready var anim: AnimationPlayer = $Anim


@onready var floor_point = $FloorPoint
	

@export var water : MeshInstance3D
@export var water_force = 10.
@export var water_drag := 0.05
@export var water_angular_drag := 0.05

var submerged := false



func move_camera_on_dock() -> void:
	anim.stop()
	anim.play("camera_on_dock")


func move_camera_on_raft() -> void:
	anim.stop()
	anim.play("camera_on_raft")


func _align_with_floor(floor_normal: Vector3) -> Transform3D:
	var xform: Transform3D = global_transform
	xform.basis.y = floor_normal
	xform.basis.x = -xform.basis.z.cross(floor_normal)
	xform.basis = xform.basis.orthonormalized()
	return xform


func set_forward_speed(speed: float) -> void:
	forward_speed = speed


func add_packet(index: int) -> void:
	var box = box.instantiate()
	get_parent().add_child(box)
	box.name = str(index)
	box.position = position + Vector3(0., 100., 0.)


#func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#print("added")
	#add_packet(1)


func _player_movement_and_rotation() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction_impact: Vector3 = Vector3(0., 0., 1.)
	if Input.is_action_pressed("ui_right"):
		direction_impact.x -= 1
	if Input.is_action_pressed("ui_left"):
		direction_impact.x += 1
	if Input.is_action_pressed("ui_down"):
		direction_impact.z -= 0.3
	
	# cheap player rotation
	#if input_dir != Vector2(0, 0):
		#$MeshInstance3D.rotation_degrees.y = $CameraController.rotation_degrees.y - rad_to_deg(input_dir.angle()) + 75
	
	# floor alignment
	$RayCast3D.position = position
	if is_on_floor():
		global_transform = global_transform.interpolate_with(
			_align_with_floor($RayCast3D.get_collision_normal()),
			0.3
		)
	elif not is_on_floor():
		global_transform = global_transform.interpolate_with(_align_with_floor(Vector3.UP), 0.3)
	
	direction = lerp(direction, direction_impact, 0.015)
	var tilt: float = direction.x * 90
	$MeshInstance3D.rotation_degrees.z = tilt
	$RaftCollision.rotation_degrees.z = tilt
	
	# movement
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * (forward_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()


# Sensitivity of the mouse movement
var sensitivity: float = 0.1
# Limits for rotation
var min_rotation_x: float = -30.0
var max_rotation_x: float = 30.0

# Store the current rotation
var rotation_x: float = 0.0
var rotation_y: float = 0.0

func _camera_handle() -> void:
	if Input.is_action_just_pressed("cam_left"):
		$CameraController.rotate_y(deg_to_rad(-45))
	if Input.is_action_just_pressed("cam_right"):
		$CameraController.rotate_y(deg_to_rad(45))
	$CameraController.position = lerp($CameraController.position, position, 0.2)
	
	#var mouse_movement = Input.get_mouse_motion()
	#rotation_x -= mouse_movement.y * sensitivity
	#rotation_x = clamp(rotation_x, min_rotation_x, max_rotation_x)
	#rotation_degrees.x = rotation_x
	#rotation_degrees.y = rotation_y
	#var camera_offset = Vector3(0, 0, -10)  # Move the camera back
	#global_transform.origin = camera_offset.rotated(Vector3.UP, rotation_y)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	submerged = false
	var point_global = floor_point.global_position
	var depth = water.get_height(point_global) - point_global.y 
	if depth > 0:
		submerged = true
		var vertical_velocity = Vector3.UP * depth * water_force
		velocity += vertical_velocity
		var drag_velocity = -velocity.y * water_drag * delta
		velocity += Vector3.UP * drag_velocity
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	_player_movement_and_rotation()


func _process(delta: float) -> void:
	_camera_handle()

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity *=  1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag 
	
