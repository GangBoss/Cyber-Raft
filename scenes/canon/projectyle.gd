extends RigidBody3D

@export var lifetime: float = 10.0

var _timer: float = 0.0

func _ready():
	_timer = lifetime

func _physics_process(delta):
	_timer -= delta
	if _timer <= 0.0:
		queue_free() 
