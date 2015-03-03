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

uniform sampler2D DepthTexture;

                  
in vec2 texcoord;
out vec4 color;


// from 
// https://www.opengl.org/discussion_boards/showthread.php/176091-Questions-about-outline-fragment-shader?p=1229876#post1229876
float linearizeDepth( in float z )
{
    return (2.0 * ClippingPlanes.x) / (ClippingPlanes.y + ClippingPlanes.x - z * (ClippingPlanes.y - ClippingPlanes.x));
}

// from
// http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main()
{
    float depth = texture2D( DepthTexture, texcoord ).r;
    depth = linearizeDepth(depth);
    color.rgb = hsv2rgb(vec3(depth,1.0,1.0-depth));
}
