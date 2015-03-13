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

in vec3 Position;

out vec3 texcoord;

void main()
{
    vec3 position = mat3(ViewMatrix) * Position;
    gl_Position = ProjectionMatrix*vec4(position,1.0);
    
    gl_Position.z = gl_Position.w -0.00001; // fix to far plane
    texcoord = Position;
}