#version 430

layout(local_size_x=4, local_size_y=4) in;

layout(r8, binding=0) uniform image2D Input;
layout(r8, binding=1) uniform image2D Output;

shared float Occlusion[8][8];

void main()
{
    ivec2 LocalID = ivec2( gl_LocalInvocationID.xy );
    ivec2 GlobalID = ivec2( gl_GlobalInvocationID.xy );
    
    // Step 1. Read our data
    {
        ivec2 GlobalPos = ivec2(gl_WorkGroupID.xy) * 4;
        ivec2 BufferIndex = (LocalID - ivec2(2)) * 2;
        
        for( int y=0; y < 2; ++y ) {
            for( int x=0; x < 2; ++x ) {
                ivec2 pos = GlobalPos + BufferIndex + ivec2(x,y);
                pos = clamp( pos, ivec2(0), imageSize(Input)-ivec2(1) );
                
                Occlusion[y + LocalID.y*2][x + LocalID.x*2] = imageLoad( Input, pos ).xyz;
            }
        }
    }
    
    // make sure that all invocations have reached this point & that their writes are visible
    memoryBarrierShared();
    barrier();
    
    /// Step 2. do the blur :)
    {
        float acc = 0.0;
        float count = 0.0;
        
        for( int y=0; y < 4; ++y ) {
            for( int x=0; x < 4; ++x ) {
                acc += Occlusion[LocalID.y+y][LocalID.x+x];
                count += 1.0;
            }
        }
        
        acc /= count;
        imageStore( Output, GlobalID, vec4(acc) );
    }
}


