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

layout(std140) uniform BoxLight
{
    uniform mat4 ModelMatrix; 
    uniform vec4 Color;
    uniform vec3 InnerSize, OuterSize;
};


uniform sampler2D DiffuseTexture;
uniform sampler2D NormalTexture;
uniform sampler2D DepthTexture;
uniform sampler2D PositionTexture;

in vec3 BoxDir[3];
out vec4 color;

void main()
{
    ivec2 texcoord = ivec2(gl_FragCoord.xy);
    vec3 Position = ModelMatrix[3].xyz;
    
    vec3 gPosition = texelFetch( PositionTexture, texcoord, 0 ).xyz;
    vec3 gNormal = texelFetch( NormalTexture, texcoord, 0 ).xyz*2.0 - 1.0;
    vec4 gDiffuse = texelFetch( DiffuseTexture, texcoord, 0 );
    
    vec3 lightDirection = gPosition-Position;
    
    vec3 dist = smoothstep( OuterSize, InnerSize,
                            vec3(
                                abs(dot(lightDirection,BoxDir[0])), 
                                abs(dot(lightDirection,BoxDir[1])), 
                                max(dot(lightDirection,BoxDir[2]),0.0)
                            )
    );
    lightDirection = normalize(lightDirection);
    
//     color.rgb =  vec3(dist.x*dist.y);
//     return;
    float diffuse = max( 0.0, dot(-BoxDir[2],gNormal) );
    
    vec3 reflection = reflect(lightDirection, gNormal);
    
    vec3 eyeDir = normalize(CameraPosition-gPosition);
    float specular = max( dot(reflection, eyeDir), 0.0 );
    specular = pow(specular,15) * gDiffuse.a;
    
    float mod = dist.x*dist.y*dist.z;
    if( diffuse == 0.0 ) {
        mod = 0.0;
    }
    
    color.rgb = gDiffuse.rgb * (Color.rgb+specular+diffuse) * mod * Color.a;
}
