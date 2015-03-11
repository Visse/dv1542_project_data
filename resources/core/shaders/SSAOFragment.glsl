#version 430

layout(std140) uniform SceneInfo 
{
    mat4 ViewMatrix, 
         ProjectionMatrix, 
         ViewProjMatrix,
         
         InverseViewMatrix,
         InverseProjectionMatrix,
         InverseViewProjMatrix;
         
    vec2 ClippingPlanes;
    vec3 CameraPosition;
};

in vec2 texcoord;

out vec4 color;

uniform sampler2D NormalTexture;
uniform sampler2D DepthTexture;
uniform sampler2D NoiseTexture;

uniform float SampleRadius, DepthEdge;

vec3 extractViewPosition( vec2 screenPos )
{
    vec4 pos = vec4( screenPos, texture2D(DepthTexture,screenPos).r, 1.0 );
    pos = pos * 2 - 1;
    
    pos = InverseProjectionMatrix * pos;
    
    return pos.xyz / pos.w;
}

// from 
// https://www.opengl.org/discussion_boards/showthread.php/176091-Questions-about-outline-fragment-shader?p=1229876#post1229876
float linearizeDepth( in float z )
{
    return (2.0 * ClippingPlanes.x) / (ClippingPlanes.y + ClippingPlanes.x - z * (ClippingPlanes.y - ClippingPlanes.x));
}


void main(void)
{
//     const float SampleRadius = 1;
    const int SampleCount = 1;
    
    /// @todo move to uniform
    const vec2 NoiseScale = vec2( 720.0/4.0, 1280.0/4.0 );
    
    const vec3 RandHemiSphere[10] = {
        normalize(vec3(-0.331451049514,-0.786238961631, 0.723030122216)),
        normalize(vec3(-0.108108022648, 0.118353617714, 0.802772863735)),
        normalize(vec3( 0.191178016491,-0.389099777370, 0.866525883234)),
        normalize(vec3(-0.881148550064, 0.067420768992, 0.079617613692)),
        normalize(vec3(-0.178841009594, 0.107778009449, 0.125870360192)),
        normalize(vec3( 0.686652239045,-0.063454984375, 0.654649008807)),
        normalize(vec3( 0.373499607762, 0.282126993528, 0.362054505761)),
        normalize(vec3(-0.205528281350,-0.020937298862, 0.658507674723)),
        normalize(vec3( 0.025547340913,-0.847058099257, 0.398942115953)),
        normalize(vec3(-0.513415830023,-0.712081340813, 0.172508716924))
    };
    
    vec3 normal = texture2D( NormalTexture, texcoord ).xyz * 2.0 - 1.0;
    vec3 origin = extractViewPosition( texcoord );
    
    float depth = linearizeDepth( texture2D(DepthTexture, texcoord).r );
    
    vec3 rvec = texture2D(NoiseTexture, texcoord * NoiseScale).xyz * 2.0 - 1.0;
    vec3 tangent = normalize(rvec - normal * dot(rvec, normal));
    vec3 bitangent = cross(normal, tangent);
    mat3 tbn = mat3(tangent, bitangent, normal);
    
    float occlusion = 0.0;
    for (int i = 0; i < SampleCount; ++i) {
        vec3 samplePos = tbn * RandHemiSphere[i%10];
        samplePos = samplePos * SampleRadius + origin.xyz;
        
        vec4 offset = vec4(samplePos, 1.0);
        offset = ProjectionMatrix * offset;
        offset.xy /= offset.w;
        offset.xy = offset.xy * 0.5 + 0.5;
        
        vec2 sampleCoords = offset.xy;
//         sampleCoords = clamp( sampleCoords, vec2(0), vec2(1) );
        
        // get sample depth:
        float sampleDepth = linearizeDepth( texture2D(DepthTexture, sampleCoords).r );
        
        vec3 sampleNormal = texture2D(NormalTexture, sampleCoords).xyz * 2 - 1;
        
        float angleMod = 1.0 - abs(dot(normal,sampleNormal));
        float depthCheck = abs(depth-sampleDepth) < DepthEdge ? 1.0 : 0.0;
        
        occlusion += angleMod;
    }
    
    color.rgb = vec3(1.0 - occlusion / SampleCount);
//     color.rgb = vec3(depth);
}