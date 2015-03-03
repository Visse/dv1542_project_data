#version 430

layout(std140) uniform SceneInfo {
    mat4 ViewMatrix, 
         ProjectionMatrix, 
         ViewProjMatrix,
         
         InverseViewMatrix,
         InverseProjectionMatrix,
         InverseViewProjMatrix;
         
    vec2 ClippingPlanes;
    vec3 CameraPosition;
};

layout(std140) uniform Entity {
    mat4 ModelMatrix; 
};

in vec3 Position;
in vec3 Normal;
in vec3 Tangent;
in vec3 Bitangent;
in vec2 TexCoord;

out FragmentData {
    vec3 normal, tangent, bitangent;
    vec3 position;
    vec2 texCoord;
} frag;

void main()
{
    gl_Position = ViewProjMatrix * ModelMatrix * vec4(Position,1.0);
    
    mat3 modelMatrix = mat3(ModelMatrix);
    
    frag.normal    = modelMatrix * normalize(Normal);
    frag.tangent   = modelMatrix * normalize(Tangent);
    frag.bitangent = modelMatrix * normalize(Bitangent);
    frag.texCoord = TexCoord;
    frag.position =  vec3(ModelMatrix * vec4(Position,1.0));
}
