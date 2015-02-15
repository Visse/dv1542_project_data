#version 430 core

layout(std140) uniform SceneInfo {
    mat4 ViewMatrix, 
         ProjectionMatrix, 
         ViewProjMatrix;
};

layout(std140) uniform ComputeParticle {
    mat4 ModelMatrix;
    float Intensity, 
          PointSize;
};

in vec4 particle;
out float lifeTime;

void main()
{
    gl_Position = ViewProjMatrix * ModelMatrix * vec4(particle.xyz,1.0);
    lifeTime = particle.w;
    gl_PointSize = PointSize/gl_Position.w;
}

