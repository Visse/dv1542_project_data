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

layout(std140) uniform PointLight 
{
    uniform mat4 ModelMatrix; 
    uniform vec4 Color;
    uniform vec2 Radius;
};

uniform sampler2D DiffuseTexture;
uniform sampler2D NormalTexture;
uniform sampler2D DepthTexture;

out vec4 color;

vec3 extractPositionFromDepth( float depth )
{
    vec4 pos = vec4( gl_FragCoord.xy / textureSize(DepthTexture,0).xy, depth, 1 );
    pos = pos*2 - 1;
    
    pos = InverseViewProjMatrix * pos;
    
    return pos.xyz / pos.w;
}

void main()
{
    ivec2 texcoord = ivec2(gl_FragCoord.xy);
    vec3 Position = ModelMatrix[3].xyz;
    
    vec3 gPosition = extractPositionFromDepth( texelFetch(DepthTexture, texcoord, 0) );
    vec3 gNormal = texelFetch( NormalTexture, texcoord, 0 ).xyz * 2.0 - 1.0;
    vec4 gDiffuse = texelFetch( DiffuseTexture, texcoord, 0 );
    
    vec3 lightDirection = gPosition-Position;
    float lightDistance = length(lightDirection);
    
    lightDirection /= lightDistance;
        
    float attenuation = smoothstep( Radius.y, Radius.x, lightDistance );
    
    float diffuse = dot(-lightDirection,gNormal);
    
    vec3 reflection = reflect(lightDirection, gNormal);
    
    vec3 eyeDir = normalize(CameraPosition-gPosition);
    float specular = max( dot(reflection, eyeDir), 0.0 );
    specular = pow(specular,15)* gDiffuse.a;
        
    float facingLight = smoothstep( -0.5, 0.0, diffuse );
    
    color.rgb = gDiffuse.rgb * (Color.rgb+specular+diffuse) * attenuation * Color.a * facingLight;
}
