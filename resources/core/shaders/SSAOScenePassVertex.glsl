#version 430

layout(std140) uniform SceneInfo 
{
    mat4 ViewMatrix, 
         ProjectionMatrix, 
         ViewProjMatrix,
         
         InverseViewMatrix,
         InverseProjectionMatrix,
         InverseViewProjMatrix;
         
    vec2 ClippingPlanes;
    vec3 CameraPosition;
};

layout(std140) uniform Model {
    mat4 ModelMatrix;
};

in vec3 Position;
in vec3 Normal;

out VertexData {
    vec3 normal;
} vert;

void main()
{
    gl_Position = ViewProjMatrix * ModelMatrix * vec4(Position,1.0);
    vert.normal = (ViewMatrix * ModelMatrix * vec4(Normal,0.0)).xyz;
}