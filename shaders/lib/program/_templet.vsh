// ======== preprocess ========

#define tsh_PROGRAM_vsh

// ======== input ========

// ======== output ========

out vec2 texCoord;

// ======== uniform ========

// ======== constant and function ========

#include "/lib/color.glsl"
#include "/lib/constant.glsl"
#include "/lib/function.glsl"

void main() {

    // ======== write values to output variables ========

    texCoord = gl_MultiTexCoord0.xy;

    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;

}