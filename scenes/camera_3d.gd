extends Camera3D

@export var target:Node3D
@export var distance:float

func _process(delta):
	look_at_from_position(global_position, target.position, Vector3.UP)
	
	position = target.position + (position - target.position).normalized() * distance
   
