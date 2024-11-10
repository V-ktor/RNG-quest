shader_type canvas_item;

uniform float progress = 1.0;

void fragment() {
	float w = clamp(100.0 * (progress - SCREEN_UV.x), 0.0, 1.0);
	COLOR.a *= w;
}
