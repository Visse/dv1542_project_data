#version 430

layout(std140) uniform SceneInfo 
{
    mat4 ViewMatrix, 
         ProjectionMatrix, 
         ViewProjMatrix,
         
         InverseViewMatrix,
         InverseProjectionMatrix,
         InverseViewProjMatrix;
         
    vec2 ClippingPlanes, WindowSize;
    vec3 CameraPosition;
};

layout(std140) uniform WaterUniforms {
    mat4 ModelMatrix;
    float DepthFalloff,
          HeightScale;
    vec2 ScrollDirection;
    float CurrentTime,
          LODScale;
          
    vec3 LightPosition,
         LightColor;
};



uniform sampler2D DepthTexture;
uniform sampler2D ColorTexture;
uniform sampler2D WaterTexture;
uniform sampler2D NormalTexture;

in vec2 Texcoord;
in vec3 Normal, Tangent, Bitangent;
in vec3 Position;

out vec4 color;

// from 
// https://www.opengl.org/discussion_boards/showthread.php/176091-Questions-about-outline-fragment-shader?p=1229876#post1229876
float linearizeDepth( in float z )
{
    return (2.0 * ClippingPlanes.x) / (ClippingPlanes.y + ClippingPlanes.x - z * (ClippingPlanes.y - ClippingPlanes.x));
}


void main()
{
    float curDepth = linearizeDepth(texture2D( DepthTexture, gl_FragCoord.xy/WindowSize ).r);
    float dDepth = curDepth - linearizeDepth(gl_FragCoord.z);
    color.a = smoothstep( 0.0, DepthFalloff, dDepth );
    
    vec2 texcoord = Texcoord + ScrollDirection * CurrentTime;
    
    color.rgb = texture2D( ColorTexture, texcoord ).rgb;
    
    mat3 tangentMat = (mat3(
        normalize(Tangent),  normalize(Bitangent), normalize(Normal)
    ));
    
    vec3 normal = texture2D( NormalTexture, texcoord ).xyz*2-1;
    normal = normalize( tangentMat * normal );
    
    vec3 lightDir = normalize(Position-LightPosition);

    vec3 reflection = reflect(lightDir, normalize(normal) );
    
    vec3 eyeDir = normalize(CameraPosition-Position);
    float specular = max( dot(reflection, eyeDir), 0.0 );
    specular = pow(specular, 100);
    
    color.rgb += vec3(specular) * LightColor;
//     color.rgb = normal;
//     color.a = 1.0;
}


