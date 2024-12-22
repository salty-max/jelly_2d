#version 330 core
out vec4 frag_color;

in vec2 uvs;

uniform vec4 u_color;
uniform sampler2D u_texture_id;

void main() {
	frag_color = texture(u_texture_id, uvs) * u_color;
}