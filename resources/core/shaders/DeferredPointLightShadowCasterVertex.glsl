#version 430

layout(std140) uniform ShadowModel {
    mat4 ModelMatrix;
};

in vec3 Position;


void main()
{
    gl_Position =  ModelMatrix * vec4(Position,1.0);
}