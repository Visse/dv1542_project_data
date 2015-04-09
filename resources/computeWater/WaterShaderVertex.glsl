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

layout(std140) uniform WaterUniforms {
    mat4 ModelMatrix;
    float DepthFalloff,
          HeightScale;
    vec2 ScrollDirection;
    float CurrentTime,
          LODScale;
          
    vec3 LightPosition,
         LightColor;
};

in vec3 Position;
in vec2 Texcoord;

out VertexData {
    vec2 Texcoord;
} vert;

void main() {
    gl_Position = ModelMatrix * vec4(Position,1.0);
    vert.Texcoord = Texcoord;
}
