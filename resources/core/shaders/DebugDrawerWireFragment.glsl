#version 430

layout(std140) uniform DebugWireframe {
    mat4 ModelMatrix;
    vec4 Color;
};

out vec4 color;

void main()
{
    color = Color;
}