extends Node2D

@onready var index_text: RichTextLabel = %Index
@onready var packet: Sprite2D = $Packet

@export var speed: Vector2 = Vector2(150, 150) 
var direction: Vector2

func set_index(idx : int) -> void:
	index_text.text = "[color=black][font_size=60]" + str(idx)


func _ready() -> void:
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()


func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	var screen_size = get_viewport_rect().size
	var sprite_size = packet.texture.get_size() * packet.scale

	if position.x < 0 or position.x + sprite_size.x > screen_size.x:
		direction.x = -direction.x
		position.x = clamp(position.x, 0, screen_size.x - sprite_size.x)
	if position.y < 0 or position.y + sprite_size.y > screen_size.y:
		direction.y = -direction.y
		position.y = clamp(position.y, 0, screen_size.y - sprite_size.y)
