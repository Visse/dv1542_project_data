#version 430 core

layout(std140) uniform SceneInfo {
    mat4 ViewMatrix, 
         ProjectionMatrix, 
         ViewProjMatrix;
};

layout(std140) uniform ComputeAttractors {
    mat4 ModelMatrix;
};

in vec4 attractor;

void main()
{
    gl_Position = ViewProjMatrix * ModelMatrix * vec4(attractor.xyz,1.0);
    gl_PointSize = 10.0 * attractor.w/gl_Position.w;
}

