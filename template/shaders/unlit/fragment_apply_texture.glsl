#version 330 core

in vec3 o_positionWorld;
in vec3 o_normalWorld;
in vec2 o_uv0;
out vec4 FragColor;

uniform vec4 color;
uniform sampler2D colorTexture;

void main() {

    FragColor =texture(colorTexture, o_uv0) * color;

}
