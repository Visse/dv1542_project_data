#version 430

uniform sampler2D DiffuseTexture,
                  NormalTexture,
                  SpecularTexture,
                  DepthTexture;
                  
uniform float NearPlane, FarPlane;
                  
                  
in vec2 texcoord;

out vec4 color;

// from 
// https://www.opengl.org/discussion_boards/showthread.php/176091-Questions-about-outline-fragment-shader?p=1229876#post1229876
float linearizeDepth( in float z )
{
  return (2.0 * NearPlane) / (FarPlane + NearPlane - z * (FarPlane - NearPlane));
}

vec3 depthToColor( float depth )
{
    vec3 color;
    color.r = abs(mod(depth,2)-1);
    color.b = clamp(depth-0.5, 0.0, 1.0);
    color.g = clamp(depth-1.5, 0.0, 2.5)/2.5;
    
    return color;
}

void main()
{
    color = texture2D( DiffuseTexture, texcoord );
//     float depth = linearizeDepth( texture2D(DepthTexture, texcoord).r )*4;
//     color.rgb = depthToColor( depth );
//     color = texture2D( NormalTexture, texcoord );
//     color.r = 1;
}
