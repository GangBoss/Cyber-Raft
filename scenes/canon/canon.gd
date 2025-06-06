extends CanonBase

# Get the 3D position of a mouse click and launch upwards with horizontal direction
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos: Vector2 = event.position
		var camera = get_viewport().get_camera_3d()
		if camera:
			var ray_origin: Vector3 = camera.project_ray_origin(mouse_pos)
			var ray_direction: Vector3 = camera.project_ray_normal(mouse_pos)
			var space_state = get_world_3d().get_direct_space_state()
			var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_direction * 1000)
			var result = space_state.intersect_ray(query)
			print("")
			var click_position: Vector3
			if result.has("position"):
				click_position = result["position"]
				print("position of click"+str(click_position))
			else:
				click_position = ray_origin + ray_direction * 10.0
			shoot(click_position)
			get_viewport().set_input_as_handled()
		else:
			printerr("No active 3D camera found in the viewport.")
