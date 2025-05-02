// ======== preprocess ========

#define tsh_PROGRAM_vsh

// ======== input ========

// ======== output ========

// ======== uniform ========

// ======== constant and function ========

#include "/lib/color.glsl"
#include "/lib/constant.glsl"
#include "/lib/function.glsl"

void main() {

    // ======== write values to output variables ========

    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;

}