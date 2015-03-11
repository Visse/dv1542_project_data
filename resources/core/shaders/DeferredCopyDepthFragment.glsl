#version 430

in vec2 texcoord;

out vec4 color;

uniform sampler2D Depth;

void main(void)
{
    gl_FragDepth = texture2D(Depth,texcoord).r;
//     color = vec4(gl_FragDepth);
}