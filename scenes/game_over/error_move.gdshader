shader_type canvas_item;

uniform vec2 tiling = vec2(2.0, 2.0);

void fragment() {
	vec2 scaled_uv = UV * tiling;
	vec2 repeated_uv = fract(scaled_uv);
	
	vec4 tex_color = texture(TEXTURE, repeated_uv);
	COLOR = tex_color;
}

void vertex() {
	UV.x += TIME * 0.1;
	UV.y += TIME * 0.1;
}
