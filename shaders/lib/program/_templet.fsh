// ======== preprocess ========

#define tsh_PROGRAM_fsh

// ======== input ========

in vec2 texCoord;

// ======== output ========

/* DRAWBUFFERS:0 */
out vec4 outColor0;

// ======== uniform ========

uniform sampler2D colortex0;

// ======== constant and function ========

#include "/lib/constant.glsl"
#include "/lib/function.glsl"

void main() {

    vec4 color = texture(colortex0, texCoord);

    // ======== write values to output variables ========

    outColor0 = color;

}