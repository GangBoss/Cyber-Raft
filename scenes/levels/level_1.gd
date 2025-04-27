extends Node3D

@onready var raft: CharacterBody3D = %Raft
@onready var music_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var ui: Control = $UI

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
