#version 430

layout (local_size_x=4, local_size_y=4) in;

layout(r8, binding=0) uniform image2D TargetImage;

uniform float time;

void main()
{
    ivec2 GlobalID = ivec2( gl_GlobalInvocationID.xy );
    
    
    const int WaveCount = 4;
    const vec2 WaveLengths[WaveCount] = {
        {1.0/113.0,1.0/123.0},
        {1.0/51.0,-1.0/64.0},
        {1.0/34, 1.0/20.0},
        {1.0/10.0, 1.0/24}
    };
    
    const vec2 WaveSpeeds[WaveCount] = {
        {0.2, 0.2},
        {0.6,-0.7},
        {1.2,0.9},
        {-0.9,-1.2}
    };
    const float WaveScales[WaveCount] = {
        0.5,
        0.3,
        0.15,
        0.05
    };
    
    float result = 0.0;
    for( int i=0; i < WaveCount; ++i ) {
        vec2 tmp = sin( vec2(GlobalID)*WaveLengths[i] + WaveSpeeds[i]*time );
        result += (tmp.x + tmp.y) * 0.5 * WaveScales[i];
    }
    
    imageStore( TargetImage, GlobalID, vec4(result*0.5+0.5) );
}