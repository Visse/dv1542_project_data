#version 430


in VertexData {
    vec3 normal;
} vert;

out vec3 normal;

void main()
{
    normal = normalize(vert.normal)*0.5+0.5;
}