#version 430

layout(triangles) in;
layout(triangle_strip, max_vertices = 18) out;

layout(std140) uniform ShadowUniforms {
    mat4 viewProjMatrix[6];
    vec3 lightPosition;
    vec2 clippingPlanes;
};

out vec3 position;

void main()
{
    for( int j=0; j < 6; ++j ) {
        for( int i=0; i < 3; ++i ) {
            gl_Layer = j;
            gl_Position = viewProjMatrix[j] * gl_in[i].gl_Position;
            position = gl_in[i].gl_Position.xyz;
            EmitVertex();
        }
        EndPrimitive();
    }
}
