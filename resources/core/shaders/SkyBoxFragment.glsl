#version 330

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

uniform samplerCube SkyBox;

in vec3 texcoord;

out vec4 color;

void main()
{
   color = texture( SkyBox, normalize(texcoord) );
//    color = vec4(1,0,1,1);
}