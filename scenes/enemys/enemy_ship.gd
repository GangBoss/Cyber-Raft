extends Node3D

@onready var bar = $SubViewport/ProgressBar
var max_health=3
var hit_damage=1

func _ready() -> void:
	bar.max_value = max_health
	bar.value = max_health
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if bar.value > 0:
		bar.value -= hit_damage
		if bar.value <= 0:
			queue_free()
