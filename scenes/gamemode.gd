extends Node3D
@onready var ui: Control = $UI
@onready var raft: CharacterBody3D = %Raft
@onready var music_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var grain: Sprite2D = %Grain
@onready var glitch: BackBufferCopy = $Effects/BackBufferCopy3



var boxes: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_player.play()


func fill_array_with_random_boxes() -> Array:
	var size = randi() % 5 + 3
	
	while boxes.size() < size:
		var random_number = randi() % 9 + 1
		if not boxes.has(random_number):
			boxes.append(random_number)
	
	boxes.sort()
	return boxes


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("On station")
	raft.move_camera_on_dock()
	raft.set_forward_speed(0.0)
	
	fill_array_with_random_boxes()
	ui.start_dock_game(boxes)
	
	#get_tree().change_scene("res://scenes/level_1.tscn")


func _on_raft_cubes_changed(cubes: int) -> void:
	ui.show_red_text()


func _on_raft_death() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over/game_over.tscn")


func _on_ui_packet_loss() -> void:
	glitch.visible = true
	raft.decrease_health()
	await get_tree().create_timer(0.2).timeout
	glitch.visible = false


func _on_ui_packet_sent() -> void:
	pass # Replace with function body.


func _on_ui_timeout() -> void:
	raft.move_camera_on_raft()
	await get_tree().create_timer(1.0).timeout
	raft.set_forward_speed(4.5)

func _on_next_level_trigger_body_entered(body: Node3D) -> void:
	grain.visible = true
	get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")


func _on_raft_got_damage() -> void:
	glitch.visible = true
	await get_tree().create_timer(0.2).timeout
	glitch.visible = false
