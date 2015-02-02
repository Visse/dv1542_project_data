#version 430

layout(std140) uniform SceneInfo {
    mat4 ViewMatrix, 
         ProjectionMatrix, 
         ViewProjMatrix;
};
uniform mat4 ModelMatrix; 

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
    
    mat3 viewModelMatrix = mat3(ViewMatrix * ModelMatrix);
    
    frag.normal    = viewModelMatrix * Normal;
    frag.tangent   = viewModelMatrix * Tangent;
    frag.bitangent = viewModelMatrix * Bitangent;
    frag.texCoord = TexCoord;
    frag.position = Position;
}
