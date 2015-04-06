#version 430


in vec2 texcoord;
out vec4 color;

uniform sampler2D Texture;

void main()
{
    color = texture2D(Texture,texcoord);
}