// ======== preprocess ========

#define tsh_PROGRAM_vsh

// ======== input ========

in vec2 vaUV0;
in vec3 vaPosition;

// ======== output ========

out vec2 texCoord;

// ======== uniform ========

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

// ======== constant and function ========

#include "/lib/constant.glsl"
#include "/lib/function.glsl"

void main() {

    // ======== write values to output variables ========

    texCoord = vaUV0;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition, 1.0);

}