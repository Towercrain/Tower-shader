// ======== preprocess ========

#define tsh_PROGRAM_fsh

// ======== input ========

in vec2 texCoord;

// ======== output ========

/* DRAWBUFFERS:2 */
out vec4 outColor0;

// ======== uniform ========

uniform vec2 viewResolution;

uniform sampler2D colortex0;

// ======== constant and function ========

#include "/lib/color.glsl"
#include "/lib/constant.glsl"
#include "/lib/function.glsl"

void main() {

    vec4 color2 = texture(colortex0, texCoord);

    color2.rgb *= 0.05;

    // ======== write values to output variables ========

    outColor0 = color2;

}