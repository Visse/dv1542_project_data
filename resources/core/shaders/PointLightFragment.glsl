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
uniform sampler2D PositionTexture;

out vec4 color;

void main()
{
    ivec2 texcoord = ivec2(gl_FragCoord.xy);
    vec3 Position = ModelMatrix[3].xyz;
    
    vec3 gPosition = texelFetch( PositionTexture, texcoord, 0 ).xyz;
    vec3 gNormal = texelFetch( NormalTexture, texcoord, 0 ).xyz * 2.0 - 1.0;
    vec4 gDiffuse = texelFetch( DiffuseTexture, texcoord, 0 );
    
    vec3 lightDirection = gPosition-Position;
    float lightDistance = length(lightDirection);
    
    lightDirection /= lightDistance;
        
    float attenuation = smoothstep( Radius.y, Radius.x, lightDistance );
    
    float diffuse = max( 0.0, dot(-lightDirection,gNormal) );
    
    vec3 reflection = reflect(lightDirection, gNormal);
    
    vec3 eyeDir = normalize(CameraPosition-gPosition);
    float specular = max( dot(reflection, eyeDir), 0.0 );
    
    if( diffuse == 0.0 ) {
        specular = 0.0;
    }
    else {
        specular = pow(specular,15)* gDiffuse.a;
    }
    color.rgb = gDiffuse.rgb * (Color.rgb+specular+diffuse) * attenuation * Color.a;
}
