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
    vec3 gNormal = texelFetch( NormalTexture, texcoord, 0 ).xyz;
    vec3 gDiffuse = texelFetch( DiffuseTexture, texcoord, 0 ).xyz;
    
    vec3 lightDirection = gPosition-Position;
    float lightDistance = length(lightDirection);
    
    lightDirection /= lightDistance;
        
    float attenuation = clamp( (Radius.y - lightDistance) / (Radius.y-Radius.x), 0, 1 );
    
    float diffuse = max( 0.0, dot(-lightDirection,gNormal) );

    vec3 eyeDir = mat3(ViewMatrix) * vec3(0,0,-1);
    
    vec3 reflection = reflect(lightDirection, gNormal);
    
    vec3 halfVector = normalize( eyeDir + lightDirection );
    float specular = max( dot(reflection, eyeDir), 0.0 );
    
    color.rgb = vec3(specular);
    
    if( diffuse == 0.0 ) {
        specular = 0.0;
    }
    else {
        specular = pow(specular,10);
    }
    color.rgb = gDiffuse * (Color.rgb+specular+diffuse) * attenuation * Color.a;
    
//     color.rgb = vec3(gNormal+1)/2; //vec3(diffuse);
//     color.rgb = vec3(specular);
//     color.rgb = (eyeDir);
//     color.rgb = (lightDirection+1)/2;
}
