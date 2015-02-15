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
    vec3 gNormal = texelFetch( NormalTexture, texcoord, 0 ).xyz*2 - 1;
    vec3 gDiffuse = texelFetch( DiffuseTexture, texcoord, 0 ).xyz;
    
    vec3 lightDirection = Position - gPosition;
    float lightDistance = length(lightDirection);
    
    lightDirection /= lightDistance;
        
    float attenuation = clamp( (Radius.y - lightDistance) / (Radius.y-Radius.x), 0, 1 );
    float diffuse = max( 0.0, dot(gNormal,lightDirection) );

    vec3 eyeDir = mat3(InverseViewMatrix) * vec3(0,0,-1);
//     vec3 eyeDir = vec3(0,0,-1);
    vec3 halfVector = normalize( eyeDir + lightDirection );
    
    float specular = max( dot(gNormal, halfVector), 0.0 ) * attenuation;
    
    color.rgb = vec3(specular);
    
    if( diffuse == 0.0 ) {
        specular = 0.0;
    }
    else {
        specular = pow(specular,100)/10;
    }
    color.rgb = gDiffuse * (diffuse+specular) * attenuation * Color.rgb;
    
//     color.rgb = vec3(specular);
//     color.rgb = (gNormal+1)/2;
//     color.rgb = lightDirection;
}
