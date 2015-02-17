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

layout(std140) uniform SpotLight
{
    uniform mat4 ModelMatrix; 
    uniform vec4 Color;
    uniform vec2 Angle, 
                 Distance;
};

uniform sampler2D DiffuseTexture;
uniform sampler2D NormalTexture;
uniform sampler2D DepthTexture;
uniform sampler2D PositionTexture;

in vec3 LightDirection;

out vec4 color;

void main()
{
    ivec2 texcoord = ivec2(gl_FragCoord.xy);
    vec3 Position = ModelMatrix[3].xyz;
    
    vec3 gPosition = texelFetch( PositionTexture, texcoord, 0 ).xyz;
    vec3 gNormal = texelFetch( NormalTexture, texcoord, 0 ).xyz;
    vec3 gDiffuse = texelFetch( DiffuseTexture, texcoord, 0 ).xyz;
    
    vec3 lightDirection = gPosition-Position;
    
    float lightDistance = dot( lightDirection, LightDirection );
    lightDirection = normalize( lightDirection );
    float distanceMod = smoothstep( Distance.y, Distance.x, lightDistance );
    
    float angleMod = smoothstep( 
        Angle.y, Angle.x, dot(lightDirection,LightDirection)
    );

    float diffuse = max( 0.0, dot(-lightDirection,gNormal) );
    
    vec3 reflection = reflect(lightDirection, gNormal);
    
    vec3 eyeDir = normalize(CameraPosition-gPosition);
    float specular = max( dot(reflection, eyeDir), 0.0 );
    specular = pow(specular,15);
    
    float mod = angleMod * distanceMod;
    
    if( diffuse == 0.0 ) {
        mod = 0.0;
    }
    color.rgb = gDiffuse * (Color.rgb+specular+diffuse) * mod * Color.a;
}
