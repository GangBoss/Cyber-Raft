extends MeshInstance3D

var material: ShaderMaterial

var time : float;
var noise: Image
var wave_scale: float;
var wave_strength: float;

func _ready() -> void:
	material = mesh.surface_get_material(0)
	noise = material.get_shader_parameter("noise_texture").noise.get_seamless_image(512, 512)
	wave_scale = material.get_shader_parameter("wave_scale")
	wave_strength = material.get_shader_parameter("wave_strength")
	
func _process(delta: float) -> void:
	time += delta
	material.set_shader_parameter("wave_time", time)
	
func get_height(world_position: Vector3) -> float:
	var uv_x = wrapf(world_position.x * wave_scale, 0, 1)
	var uv_y = wrapf(world_position.y * wave_scale, 0, 1)
	
	var pixel_pos = Vector2(uv_x * noise.get_width(), uv_y * noise.get_height())
	var noise_value = noise.get_pixelv(pixel_pos).r
	return sin(world_position.x * 0.2 + global_position.y *0.2 + time + noise_value + 10.0 ) * wave_strength
	
	
