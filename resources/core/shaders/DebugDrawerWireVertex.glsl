#version 430

layout(std140) uniform SceneInfo {
    mat4 ViewMatrix, 
         ProjectionMatrix, 
         ViewProjMatrix;
};

layout(std140) uniform DebugWireframe {
    mat4 ModelMatrix;
    vec4 Color;
};

in vec3 Position;

void main()
{
    gl_Position = ViewProjMatrix * ModelMatrix * vec4(Position,1.0);
    // ofsset our position so we don't zfight so mush :)
    gl_Position.z -= 0.0005;
}