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

layout(std140) uniform Model
{
    mat4 ModelMatrix;
} light;

in vec3 Position;

void main()
{
    gl_Position = ViewProjMatrix * light.ModelMatrix * vec4(Position,1.0);
}
