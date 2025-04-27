# Projectile.gd
# Attach this script to the root RigidBody3D of your projectile scene.
extends RigidBody3D

# Optional: Maximum lifetime of the projectile in seconds
@export var lifetime: float = 10.0

var _timer: float = 0.0

func _ready():
	# Set the timer to the lifetime when the projectile is ready
	_timer = lifetime
	# You could connect the body_entered signal here if needed
	connect("body_entered", Callable(self, "_on_body_entered"))


func _physics_process(delta):
	_timer -= delta
	if _timer <= 0.0:
		queue_free() 


# Optional: Handle collisions
func _on_body_entered(body):
	print("Projectile hit: ", body.name)
	queue_free()
