extends Control

@export var boxes : Array
var falling_labels = [] # stores dictionaries with label and speed

const FALL_SPEED := 60.0 # normal fall speed
const FAST_FALL_SPEED := 500.0 # speed after correct input
const SCREEN_TOP := -50.0 # starting y position
const SCREEN_BOTTOM := 800.0 # remove after this y (adjust for your screen size)


func _input(event):
	if event is InputEventKey and event.pressed:
		var key_number = event.keycode - KEY_0 # KEY_1, KEY_2 etc.
		if key_number >= 1 and key_number <= 9:
			for data in falling_labels:
				if data["active"] and int(data["label"].text) == key_number:
					data["speed"] = FAST_FALL_SPEED
					break


func spawn_labels():
	var spacing = 80 # how much space between labels
	for i in boxes.size():
		var label = Label.new()
		label.text = str(boxes[i])
		label.position = Vector2(40 + i * spacing, SCREEN_TOP)
		print(label.position)
		label.add_theme_font_size_override("font_size", 32)
		add_child(label)
		falling_labels.append({
			"label": label,
			"speed": FALL_SPEED,
			"number": boxes[i],
			"active": true
		})

func start_mini_game() -> void:
	spawn_labels()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_mini_game()


func show_red_text(time: float = 2.0):
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0) \
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	await get_tree().create_timer(time).timeout
	tween.tween_property(self, "modulate:a", 1.0, 1.0) \
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)


func add_packet_loss():
	modulate.a = 0


func _process(delta: float) -> void:
	for data in falling_labels:
		if data["active"]:
			var label = data["label"]
			label.position.y += data["speed"] * delta
			if label.position.y > SCREEN_BOTTOM:
				data["active"] = false
				label.queue_free()
