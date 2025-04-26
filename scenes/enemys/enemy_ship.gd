extends CharacterBody3D

@export var speed: float = 5.0
var player: Node3D


func _ready() -> void:
	player = get_tree().get_root().find_node("Raft", true, false)

func _physics_process(delta: float) -> void:
	player = get_tree().get_root().find_node("Raft", true, false)
	if player:
		var direction = (player.global_transform.origin - global_transform.origin)
		direction.y = 0
		direction = direction.normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		move_and_slide()
		
func _handle_collision(collider: Object) -> void:
	if collider.name == "Raft":
		get_tree().quit()
