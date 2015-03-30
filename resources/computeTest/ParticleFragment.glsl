#version 430 core

layout(std140) uniform ComputeParticle {
    mat4 ModelMatrix;
    float Intensity, 
          PointSize;
};

out vec4 color;

in float lifeTime;

const vec4 Color1 = vec4(0.0,  0.8, 0.2, 0.0);
const vec4 Color2 = vec4(0.0, 0.0, 0.8, 1.0);
const vec4 Color3 = vec4(0.0, 0.2, 0.0, 0.0);

void main()
{
    // mix our color, based on our current lifetime
    float lifeFade = smoothstep(0.0, 1.0, 1-abs(1-lifeTime*2) );
    color = mix( 
        Color1, Color2, lifeFade
    );
    
    vec2 dist = gl_PointCoord - vec2(0.5);
    float shape = dot( dist, dist );
    
    if( shape > 0.25 ) {
        discard;
    }
    
    color = mix( Color3, color, smoothstep(0.0,0.25,shape) ) * Intensity;
    color.rgb *= color.a;
    
    // this out the particle as its gets closer to the camera
    color *= smoothstep(0.0,1.0, gl_FragCoord.z);
}