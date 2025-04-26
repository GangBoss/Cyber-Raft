extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var forward_speed: float = 4.5
var direction: Vector3

var box = preload("res://scenes/box.tscn")


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


func _ready() -> void:
	print("added")
	add_packet(1)


func _player_movement_and_rotation() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction_impact: Vector3 = Vector3(0., 0., 1.)
	if Input.is_action_pressed("ui_right"):
		direction_impact.x += 1
	if Input.is_action_pressed("ui_left"):
		direction_impact.x -= 1
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
	var tilt: float = -direction.x * 90
	$MeshInstance3D.rotation_degrees.z = tilt
	$RaftCollision.rotation_degrees.z = tilt
	
	# movement
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * (-forward_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()


func _camera_handle() -> void:
	if Input.is_action_just_pressed("cam_left"):
		$CameraController.rotate_y(deg_to_rad(-45))
	if Input.is_action_just_pressed("cam_right"):
		$CameraController.rotate_y(deg_to_rad(45))
	$CameraController.position = lerp($CameraController.position, position, 0.2)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	_player_movement_and_rotation()
	_camera_handle()
