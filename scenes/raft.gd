extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var forward_speed: float = 2.5
var direction: Vector3

@onready var anim: AnimationPlayer = $Anim


@onready var floor_point = $FloorPoint

@onready var right_col: CollisionShape3D = $MeshInstance3D/StaticBody3D/RightCol
@onready var left_col: CollisionShape3D = $MeshInstance3D/StaticBody3D/LeftCol
@onready var forw_col: CollisionShape3D = $MeshInstance3D/StaticBody3D/ForwCol
@onready var backw_col: CollisionShape3D = $MeshInstance3D/StaticBody3D/BackwCol

@onready var colliders = [right_col, left_col, forw_col, backw_col]
var colliders_enable = true


@export var water : MeshInstance3D
@export var water_force = 10.
@export var water_drag := 0.05
@export var water_angular_drag := 0.05

var submerged := false

var box_count = 0

@export var box_node : Resource
@onready var box_placeholders = $BoxPlaceholders.get_children()
var cubes : Array[Node3D] 

signal cubes_changed(cubes: int)



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


func add_packet(name: String, pos: Vector3) -> void:
	var box = box_node.instantiate()
	add_child(box)
	box.name = name
	box.position = pos

func add_cubes(count: int) -> void:
	remove_cubes()
	
	var b_l = box_placeholders.size()
	for i in range(count):
		var level = i / b_l
		var b = box_placeholders[i%b_l]
		add_packet(str(i), b.global_position + Vector3.UP * .1 * level)


func _ready() -> void:
	add_cubes(40)


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
	if abs($MeshInstance3D.rotation_degrees.z)> 30.:
		if colliders_enable:
			print("colliders disabled")
			colliders_enable = false
			for c in colliders:
				c.disabled = true
	else:
		if !colliders_enable:
			print("colliders enabled")
			colliders_enable = true
			for c in colliders:
				c.disabled = false
		
	
	
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

const SENSITIVITY = 0.004

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENSITIVITY)
		$CameraController.rotate_x(-event.relative.y * SENSITIVITY)
		$CameraController.rotation.x = clamp($CameraController.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _camera_handle() -> void:
	$CameraController.position = lerp($CameraController.position, position, 0.2)


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


func _on_area_3d_body_entered(body: Node3D) -> void:
	box_count += 1
	cubes.append(body)
	cubes_changed.emit(box_count)


func _on_area_3d_body_exited(body: Node3D) -> void:
	box_count -= 1
	cubes.erase(body)
	cubes_changed.emit(box_count)

func remove_cubes() -> void:
	for c in cubes:
		c.queue_free()


func _on_cubes_changed(cubes: int) -> void:
	print(box_count)
