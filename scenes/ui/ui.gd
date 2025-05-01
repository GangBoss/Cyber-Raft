extends Control

var falling_boxes : Dictionary # stores dictionaries with label and speed

@onready var red_text: RichTextLabel = $RedText


@onready var score: RichTextLabel = %Score
@onready var score_2: RichTextLabel = %Score2

@onready var big_text: RichTextLabel = $BigText
@onready var big_text_2: RichTextLabel = $BigText2
@onready var hint: RichTextLabel = %Hint
@onready var tts: RichTextLabel = %TTS


@onready var packet = preload("res://scenes/ui/packet.tscn")

signal packet_sent()
signal packet_loss()
signal timeout()

var score_total : int = 0
var timer
var gaming : bool = false


func start_dock_game(boxes: Array):
	spawn_boxes(boxes)
	
	#await mgt.ready
	#mgt.visisble = true
	hint.visible = true
	gaming = true

	timer = Timer.new()
	timer.wait_time = 7.5
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(_on_timer_time_out.bind(timer))


func end_dock_game():
	#mgt.visisble = false
	hint.visible = false
	gaming = false
	timer.queue_free()
	timeout.emit()


func _on_timer_time_out(timer: Timer):
	end_dock_game()


func _input(event):
	if gaming and event is InputEventKey and event.pressed:
		var key_number = event.keycode - KEY_0 # KEY_1, KEY_2 etc.
		if key_number >= 1 and key_number <= 9:
			if key_number in falling_boxes:
				var obj = falling_boxes[key_number]
				falling_boxes.erase(key_number)
				obj.queue_free()
				packet_sent.emit()
				if falling_boxes.is_empty():
					end_dock_game()
			else:
				packet_loss.emit()


func spawn_boxes(boxes: Array):
	for i in boxes.size():
		if int(boxes[i]) in falling_boxes:
			continue
		var cur = packet.instantiate()
		cur.position = Vector2(randf() * get_viewport().size.x, randf() * get_viewport().size.y)
		add_child(cur)
		cur.set_index(int(boxes[i]))
		falling_boxes[int(boxes[i])] = cur


func show_red_text(time: float = 2.0):
	var tween_in = create_tween()
	tween_in.tween_property(red_text, "modulate:a", 1.0, 1.0) \
		.set_ease(Tween.EASE_IN)
	
	if get_tree() == null:
		return
	await get_tree().create_timer(time).timeout
	
	var tween_out = create_tween()
	tween_out.tween_property(red_text, "modulate:a", 0.0, 1.0) \
		.set_ease(Tween.EASE_OUT)


func _physics_process(delta: float) -> void:
	if gaming and timer != null:
		var rem_time = str(int(timer.wait_time))
		tts.text = "[tornado radius=1.0 freq=1.0 connected=1][color=#00FFFF]TTS (time to stay)\n"+rem_time+"[/color][/tornado]"


func _on_packet_sent() -> void:
	var score_val = int(timer.wait_time * randi_range(90, 100))
	score_total += score_val
	score.text = "[tornado radius=3.0 freq=4.0 connected=1][color=#FF00FF]Score: " + str(score_total) + "[/color][/tornado]"
	score_2.text = "[tornado radius=3.0 freq=4.0 connected=1][color=#00FFFF]Score: " + str(score_total) + "[/color][/tornado]"
