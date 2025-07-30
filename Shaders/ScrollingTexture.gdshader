shader_type canvas_item;

uniform vec2 scrollDirection = vec2(0.0, 0.0);
uniform float scrollSpeed = 1.0;

void fragment() {
	vec2 scroll = scrollDirection * TIME * scrollSpeed;
	vec4 tex = texture(TEXTURE, vec2(UV.x, UV.y) - scroll);

	COLOR = tex;
}