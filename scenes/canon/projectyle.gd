extends RigidBody3D

@export var lifetime: float = 10.0

var _timer: float = 0.0

func _ready():
	print("projectyle position" + str(self.global_position))
	_timer = lifetime

func _physics_process(delta):
	_timer -= delta
	print("projectyle position" + str(self.global_position))
	if _timer <= 0.0:
		queue_free() 
