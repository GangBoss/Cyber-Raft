extends Node3D

@onready var raft: CharacterBody3D = %Raft
@onready var music_player: AudioStreamPlayer = $AudioStreamPlayer

var boxes: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fill_array_with_random_boxes()
	music_player.play()


func fill_array_with_random_boxes() -> Array:
	var size = randi() % 4 + 3
	
	while boxes.size() < size:
		var random_number = randi() % 9 + 1
		if not boxes.has(random_number):
			boxes.append(random_number)
	
	boxes.sort()
	return boxes


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("On station")
	raft.move_camera_on_dock()
	raft.set_forward_speed(0.0)
	await get_tree().create_timer(10.0).timeout
	
	raft.move_camera_on_raft()
	await get_tree().create_timer(1.0).timeout
	raft.set_forward_speed(4.5)
	#get_tree().change_scene("res://scenes/level_1.tscn")
