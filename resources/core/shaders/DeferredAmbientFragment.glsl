#version 430

in vec2 texcoord;

out vec4 color;

uniform sampler2D Diffuse;


uniform AmbientSettings
{
    vec3 AmbientColor;
};

void main(void)
{
    color.rgb = texture2D(Diffuse,texcoord).rgb * AmbientColor;
}