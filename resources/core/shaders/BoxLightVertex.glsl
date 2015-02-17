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

layout(std140) uniform BoxLight
{
    uniform mat4 ModelMatrix; 
    uniform vec4 Color;
    uniform vec3 InnerSize, OuterSize;
};

in vec3 Position;
in vec3 Normal;

out vec3 BoxDir[3];

void main()
{
    gl_Position = ViewProjMatrix * ModelMatrix * vec4(Position,1.0);
    
    // this fixes visual glitching (culling & clipping) when the camera is inside the light volume
    // it basicly clips everything behind the camera to the near plane, a problem with it is that it
    // doesn't handle the case then the light volume is behind the camera (its still clipped to the near plane),
    // but that case is handled by the frustrum cull
    gl_Position.w = max(gl_Position.w,0.0);
    
    mat3 modelMatrix = mat3(ModelMatrix);
    BoxDir[0] = normalize( modelMatrix * vec3(1,0,0) );
    BoxDir[1] = normalize( modelMatrix * vec3(0,1,0) );
    BoxDir[2] = normalize( modelMatrix * vec3(0,0,-1) );
}
