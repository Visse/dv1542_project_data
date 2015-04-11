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
          LODScale,
          Frensel,
          FrenselFalloff;
          
    vec3 WaterColor;
    vec3 LightPosition,
         LightColor;
};



uniform sampler2D DepthTexture;
uniform sampler2D DiffuseTexture;

uniform sampler2D ColorTexture;
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
    vec2 waterTexcoord = Texcoord + ScrollDirection * CurrentTime;
    
    float waterDepth = linearizeDepth( gl_FragCoord.z );
    
    mat3 tangentMat = (mat3(
        normalize(Tangent),  normalize(Bitangent), normalize(Normal)
    ));
    
    vec3 waterNormal = texture2D( NormalTexture, waterTexcoord ).xyz*2-1;
    waterNormal = normalize( tangentMat * waterNormal );
    
    vec3 lightDir = normalize(Position-LightPosition);

    vec3 reflection = reflect(lightDir, normalize(waterNormal) );
    
    vec3 eyeDir = normalize(CameraPosition-Position);
    float specular = max( dot(reflection, eyeDir), 0.0 );
    specular = pow(specular, 100);
    
    vec3 waterSpecular = vec3(specular) * LightColor;
    
    vec2 WindowTexcoord = gl_FragCoord.xy / WindowSize;
    float curDepth = linearizeDepth(texture2D( DepthTexture, WindowTexcoord ).r);
    
    float waterDdepth = curDepth - waterDepth;
    float waterAlpha = smoothstep( 0.0, DepthFalloff, waterDdepth );
    
    float frenselScale = curDepth - waterDepth;
    
    float frensel = Frensel * frenselScale;
    vec2 offset = waterNormal.xy * frensel;
    vec2 frenselTexcoord = clamp( WindowTexcoord+offset, vec2(0), vec2(1) );
    
    float frenselDepth = texture2D(DepthTexture, frenselTexcoord).r;
    
    vec4 frenselPos = InverseViewProjMatrix * vec4( frenselTexcoord*2-1, frenselDepth*2-1, 1.0 );
    frenselPos.xyz /= frenselPos.w;
    
    float frenselDist = distance( frenselPos.xyz, Position );
    float alpha = smoothstep( 0.0, FrenselFalloff, frenselDist );
   
    vec3 gColor = texture2D( DiffuseTexture, frenselTexcoord ).xyz;
    
    
    color.rgb = mix( gColor, WaterColor, alpha ) + waterSpecular;
}


