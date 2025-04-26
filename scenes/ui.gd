extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


#func fade_in():
	#var tween = $Tween
	#tween.tween_property(self, "modulate:a", 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)


func add_packet_loss():
	modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
