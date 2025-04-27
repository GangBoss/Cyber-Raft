extends Node2D

var amplitude: float = 20.0
var speed: float = 1.5
var start_position: Vector2
var time: float = 0.0

func _ready():
	start_position = position

func _process(delta):
	time += delta * speed
	var target_y = start_position.y + sin(time) * amplitude
	position.y = lerp(position.y, target_y, 0.1)
