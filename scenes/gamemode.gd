extends Node3D

@onready var raft: CharacterBody3D = %Raft
@onready var music_player: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	music_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("On station")
	raft.set_forward_speed(0.0)
	await get_tree().create_timer(10.0).timeout
	raft.set_forward_speed(10.0)
	#get_tree().change_scene("res://scenes/level_1.tscn")
