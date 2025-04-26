extends RigidBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var forward_speed: float = 130.
var side_speed: float = 30.
var direction: Vector3

var box = preload("res://scenes/box.tscn")


@export var float_force := 50.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var water: MeshInstance3D

@onready var probes = $Probes.get_children()

var submerged := false


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


func _physics_process(delta: float) -> void:
	var direction_impact: Vector3 = Vector3(0., 0., 1.)
	if Input.is_action_pressed("ui_right"):
		direction_impact.x += 1
	if Input.is_action_pressed("ui_left"):
		direction_impact.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction_impact.z -= 0.3
	
	_camera_handle()
	
	direction = lerp(direction, direction_impact, 0.015)
	var tilt: float = -direction.x * 90
	rotation_degrees.z = tilt
	
	var velocity: Vector3 = Vector3(
		direction.x * side_speed,
		0,
		direction.z * (-forward_speed)
	)
	apply_force(velocity, Vector3.ZERO)
	
	submerged = false
	for p in probes:
		var depth = water.get_height(p.global_position) - p.global_position.y 
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * float_force * gravity * depth, p.global_position - global_position)


func _camera_handle() -> void:
	if Input.is_action_just_pressed("cam_left"):
		$CameraController.rotate_y(deg_to_rad(-45))
	if Input.is_action_just_pressed("cam_right"):
		$CameraController.rotate_y(deg_to_rad(45))
	print(position)
	$CameraController.position = lerp($CameraController.position, position, 0.2)


func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity *=  1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag 
