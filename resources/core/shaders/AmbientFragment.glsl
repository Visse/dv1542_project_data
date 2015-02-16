#version 430

uniform sampler2D DiffuseTexture,
                  NormalTexture,
                  SpecularTexture,
                  DepthTexture,
                  PositionTexture;

uniform AmbientLight {
    vec3 AmbientColor;
};
                  
in vec2 texcoord;
out vec4 color;

void main()
{
    color = texture2D( DiffuseTexture, texcoord ) * vec4(AmbientColor,1);
    gl_FragDepth = texture2D(DepthTexture, texcoord).r;
}
