// ======== preprocess ========

#define tsh_PROGRAM_vsh

// ======== input ========

in vec3 vaPosition;

// ======== output ========

// ======== uniform ========

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

// ======== constant and function ========

#include "/lib/color.glsl"
#include "/lib/constant.glsl"
#include "/lib/function.glsl"

void main() {

    // ======== write values to output variables ========

    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition, 1.0);

}