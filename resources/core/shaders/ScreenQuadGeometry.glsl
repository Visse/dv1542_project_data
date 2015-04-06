#version 430

layout(points) in;
layout(triangle_strip, max_vertices = 4) out;

out vec2 texcoord;

layout(std140) uniform QuadInfo {
    vec2 pos, size;
};

void main()
{
    gl_Position = vec4( pos+size*vec2(-1,-1), 0.0, 1.0 );
    texcoord = vec2( 0.0, .0 );
    EmitVertex();

    gl_Position = vec4( pos+size*vec2(1,-1), 0.0, 1.0 );
    texcoord = vec2( 1.0, 0.0 ); 
    EmitVertex();

    gl_Position = vec4( pos+size*vec2(-1,1), 0.0, 1.0 );
    texcoord = vec2( 0.0, 1.0 ); 
    EmitVertex();

    gl_Position = vec4( pos+size*vec2(1,1), 0.0, 1.0 );
    texcoord = vec2( 1.0, 1.0 ); 
    EmitVertex();

    EndPrimitive(); 
}
