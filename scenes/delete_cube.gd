extends Area3D

signal cube_deleted

func _on_body_entered(body: Node3D) -> void:
	body.queue_free()
	cube_deleted.emit()
