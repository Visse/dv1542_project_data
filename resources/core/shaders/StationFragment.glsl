#version 430


in FragmentData {
    vec3 normal, tangent, bitangent;
    vec3 position;
    vec2 texCoord;
} vert;


uniform Material {
    vec3 ambient,
         specular;
};

out vec4 Diffuse;
out vec3 Normal;

uniform sampler2D DiffuseTexture;
uniform sampler2D NormalTexture;

void main()
{
    mat3 tangentToScreenSpace = transpose(mat3(
        normalize(vert.normal), normalize(vert.tangent), normalize(vert.bitangent)
    ));
    
    Diffuse = texture2D( DiffuseTexture, vert.texCoord );
    Normal  = (tangentToScreenSpace * texture2D( NormalTexture, vert.texCoord ).xyz+1)/2;
//     Normal  = (normalize(vert.tangent)+1) / 2;
//     Diffuse = texture2D( NormalTexture, vert.texCoord ) + 0.1;
}
