extends Control


var can_be_ended : bool = false

@onready var music_player: AudioStreamPlayer = $AudioStreamPlayer

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and can_be_ended:
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_anim_2_animation_finished(anim_name: StringName) -> void:
	can_be_ended = true
