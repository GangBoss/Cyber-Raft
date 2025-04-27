extends Control

@export var boxes : Array
var falling_labels : Dictionary # stores dictionaries with label and speed

const SCREEN_TOP := -50.0 # starting y position
const SCREEN_BOTTOM := 800.0 # remove after this y (adjust for your screen size)

@onready var red_text: RichTextLabel = $RedText
@onready var big_text: RichTextLabel = $BigText
@onready var big_text_2: RichTextLabel = $BigText2
@onready var hint: RichTextLabel = $Hint
@onready var packet = preload("res://scenes/ui/packet.tscn")

signal packet_sent()
signal packet_failed()
signal timeout()

func _input(event):
	if event is InputEventKey and event.pressed:
		var key_number = event.keycode - KEY_0 # KEY_1, KEY_2 etc.
		if key_number >= 1 and key_number <= 9:
			if key_number in falling_labels:
				var obj = falling_labels[key_number]
				falling_labels.erase(key_number)
				obj.queue_free()
				print("GOOD")
			else:
				print("BAD")


func spawn_labels():
	for i in boxes.size():
		var cur = packet.instantiate()
		cur.position = Vector2(randf() * get_viewport().size.x, randf() * get_viewport().size.y)
		add_child(cur)
		cur.set_index(int(boxes[i]))
		falling_labels[int(boxes[i])] = cur


func start_mini_game() -> void:
	red_text.modulate.a = 0
	spawn_labels()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_mini_game()
	add_packet_loss()


func show_red_text(time: float = 2.0):
	var tween_in = create_tween()
	tween_in.tween_property(red_text, "modulate:a", 1.0, 1.0) \
		.set_ease(Tween.EASE_IN)
	
	await get_tree().create_timer(time).timeout
	
	var tween_out = create_tween()
	tween_out.tween_property(red_text, "modulate:a", 0.0, 1.0) \
		.set_ease(Tween.EASE_OUT)


func add_packet_loss():
	show_red_text()


#func _physics_process(delta: float) -> void:
	#for data in falling_labels:
		#if data["active"]:
			#pass
