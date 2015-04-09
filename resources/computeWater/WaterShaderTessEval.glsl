#version 430

layout( quads, equal_spacing, ccw) in;

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

in TessData {
    vec2 Texcoord;
} tess[];

out vec2 Texcoord;
out vec3 Normal, Tangent, Bitangent;
out vec3 Position;

uniform sampler2D WaterTexture;

void main()
{
    float u = gl_TessCoord.x;
    float omu = 1 - u;
    float v = gl_TessCoord.y;
    float omv = 1 - v;
    
    gl_Position = omu * omv * gl_in[0].gl_Position + 
                    u * omv * gl_in[1].gl_Position +
                    u *   v * gl_in[2].gl_Position +
                  omu *   v * gl_in[3].gl_Position;
                  
    
    Texcoord = omu * omv * tess[0].Texcoord +
                 u * omv * tess[1].Texcoord +
                 u *   v * tess[2].Texcoord +
               omu *   v * tess[3].Texcoord;
    
//     vec4 heights = textureGather( WaterTexture, Texcoord, 0 );
    
    const int O = 2;
    const ivec2 offsets[4] = {
        ivec2(-O, O), 
        ivec2( O, O),
        ivec2( O,-O),
        ivec2(-O,-O)
    };
    const int SampleCount = 4;
    vec4 heights = vec4(0);
    for( int i=0; i < SampleCount; ++i ) {
        const int Dist = int(pow(2,i));
        const ivec2 offset2[4] = {
            offsets[0] * Dist,
            offsets[1] * Dist,
            offsets[2] * Dist,
            offsets[3] * Dist
        };
        heights += textureGatherOffsets(WaterTexture, Texcoord, offset2, 0) * (1.0/float(SampleCount));
    }
    heights = (heights * 2 - 1) * HeightScale;
               
    float height = (heights.x+heights.y+heights.z+heights.w)*(1.0/4.0);
    
    gl_Position += vec4( 0, height, 0, 0 );
    Position = gl_Position.xyz;
    gl_Position = ViewProjMatrix * vec4(gl_Position.xyz,1.0);
    
    const float x = 0.01;
    vec3 p01 = vec3(0,x, heights[0] ),
         p11 = vec3(x,x, heights[1] ),
         p10 = vec3(x,0, heights[2] ),
         p00 = vec3(0,0, heights[3] );
    
    vec3 n1 = cross( p01-p11, p10-p11 ),
         n2 = cross( p10-p00, p01-p00 );
    
    Normal = normalize( n1+n2 );
    
    Tangent = cross( Normal, vec3(1,0,0) );
    Bitangent = cross( Normal, vec3(0,1,0) );
    
    
}
