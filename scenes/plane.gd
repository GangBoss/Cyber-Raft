extends RigidBody3D

@export var float_force := 1.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water = get_node('/root/WaterTest/Water')

@onready var probes = $Probes.get_children()

@export var speed = 10.;
@export var turn_speed = 10.;
@export var turn_speed_down = 10;

var submerged := false

var direction:Vector3;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction = Vector3()
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_just_pressed("ui_down"):
		print("true")
		freeze = true
	if Input.is_action_just_released("ui_down"):
		print("false")
		freeze = false


func _physics_process(delta):
	apply_force(Vector3.FORWARD * delta * speed, Vector3.ZERO)
	if direction.x != 0:
		print(direction.x)
		apply_force(Vector3(direction*delta*turn_speed + Vector3.DOWN *delta*turn_speed_down),
		 direction*2)
	
	submerged = false
	for p in probes:
		var depth = water.get_height(p.global_position) - p.global_position.y 
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * float_force * gravity * depth, p.global_position - global_position)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity *=  1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag 
	
