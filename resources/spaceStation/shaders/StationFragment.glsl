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

in FragmentData {
    vec3 normal, tangent, bitangent;
    vec3 position;
    vec2 texCoord;
} vert;

out vec4 Diffuse;
out vec3 Normal;
out vec3 Position;

uniform sampler2D DiffuseTexture;
uniform sampler2D NormalTexture;
uniform sampler2D SpecularIntesity;

void main()
{
    mat3 tangentToWorldSpace = (mat3(
        normalize(vert.tangent),  normalize(vert.bitangent), normalize(vert.normal)
    ));
    
    vec3 normalMap = texture2D( NormalTexture, vert.texCoord ).xyz*2 - 1;
    
    Diffuse = texture2D( DiffuseTexture, vert.texCoord );
    Normal = normalize(tangentToWorldSpace*normalMap)*0.5+0.5;
    Position =  vert.position;
    
    Diffuse.a = texture2D(SpecularIntesity, vert.texCoord).r;
}
