#version 430


in vec2 texcoord;
out vec4 color;

uniform sampler2D Texture;

uniform Uniforms {
    vec4 quad;
    float alpha;
};

void main()
{
    color = texture2D(Texture,texcoord);
    color.a = alpha;
}