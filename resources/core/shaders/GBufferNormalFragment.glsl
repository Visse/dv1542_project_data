#version 430

uniform sampler2D NormalTexture;
                  
in vec2 texcoord;
out vec4 color;

void main()
{
    color = texture2D( NormalTexture, texcoord );
}
