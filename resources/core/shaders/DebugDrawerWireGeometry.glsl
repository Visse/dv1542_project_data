#version 430

layout(triangles) in;
layout(line_strip, max_vertices = 6) out;

#define position(i) gl_in[i].gl_Position

void main()
{
    gl_Position = position(0);
    EmitVertex();
    gl_Position = position(1);
    EmitVertex();
    gl_Position = position(2);
    EmitVertex();
    gl_Position = position(0);
    EmitVertex();
    
    EndPrimitive(); 
}