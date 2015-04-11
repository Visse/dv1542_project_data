#version 430

layout( vertices=4 ) out;

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



in VertexData {
    vec2 Texcoord;
} vert[];

out TessData {
    vec2 Texcoord;
} tess[];

void main()
{
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;
    tess[gl_InvocationID].Texcoord = vert[gl_InvocationID].Texcoord;

    vec3 midPoints[4];
    
    midPoints[0] = (gl_in[0].gl_Position + gl_in[3].gl_Position).xyz / 2.0;
    midPoints[1] = (gl_in[0].gl_Position + gl_in[1].gl_Position).xyz / 2.0;
    midPoints[2] = (gl_in[1].gl_Position + gl_in[2].gl_Position).xyz / 2.0;
    midPoints[3] = (gl_in[2].gl_Position + gl_in[3].gl_Position).xyz / 2.0;
    
    float distances[4];
    for( int i=0; i < 4; ++i ) {
        distances[i] = distance( midPoints[i], CameraPosition );
    }
    
    for( int i=0; i < 4; ++i ) {
        gl_TessLevelOuter[i] = mix( 0.0, float(gl_MaxTessGenLevel), clamp(LODScale / distances[i], 0.0, 1.0) );
    }
    
    
    vec3 mid = vec3(0);
    for( int i=0; i < 4; ++i ) {
        mid += midPoints[i] / 4.0;
    }
    
    float distToMid = distance( mid, CameraPosition );
    float innerLOD = mix( 0.0, float(gl_MaxTessGenLevel), clamp(LODScale / distToMid, 0.0, 1.0) );
    
    gl_TessLevelInner[0] = innerLOD;
    gl_TessLevelInner[1] = innerLOD;
}

