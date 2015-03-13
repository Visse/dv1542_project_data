#version 430


layout(std140) uniform ShadowUniforms {
    mat4 viewProjMatrix[6];
    vec3 lightPosition;
    vec2 clippingPlanes;
};

in vec3 position;
out vec4 color;

void main()
{
//     if( gl_Layer == 0 ) {
//         color = vec4(1,0,0,1);
//     }
//     if( gl_Layer == 1 ) {
//         color = vec4(0,1,0,1);
//     }
//     if( gl_Layer == 2 ) {
//         color = vec4(0,0,1,1);
//     }
//     
//     if( gl_Layer == 3 ) {
//         color = vec4(1,0,1,1);
//     }
//     if( gl_Layer == 4 ) {
//         color = vec4(1,1,0,1);
//     }
//     if( gl_Layer == 5 ) {
//         color = vec4(0,1,1,1);
//     }
    
    float depth = distance(position, lightPosition); 
    // to stop z-fighting
    depth += 0.1;
    gl_FragDepth = (depth - clippingPlanes.x) / clippingPlanes.y;
    
    color = vec4(0);
}