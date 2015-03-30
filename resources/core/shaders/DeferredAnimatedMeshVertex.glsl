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

layout(std140) uniform Model {
    mat4 ModelMatrix; 
};

layout(std140) buffer Skeleton {
    mat4 BoneMatrixes[];
};

in vec3 Position,
        Normal,
        Tangent,
        Bitangent;
in vec2 TexCoord;

in ivec4 BoneIndexes;
in vec4 BoneWeights;

out FragmentData {
    vec3 normal, tangent, bitangent;
    vec3 position;
    vec2 texCoord;
} frag;

void main()
{
    vec4 pos = vec4(0);
    
    for( int i=0; i < 4; ++i ) {
        pos += BoneMatrixes[BoneIndexes[i]] * vec4( Position, 1.0 ) * BoneWeights[i];
    }
    
    gl_Position = ViewProjMatrix * ModelMatrix * vec4(pos.xyz,1.0);
    
    mat3 modelMatrix = mat3(ModelMatrix);
    
    frag.normal    = modelMatrix * normalize(Normal);
    frag.tangent   = modelMatrix * normalize(Tangent);
    frag.bitangent = modelMatrix * normalize(Bitangent);
    frag.texCoord = TexCoord;
    frag.position =  vec3(ModelMatrix * vec4(Position,1.0));
}
