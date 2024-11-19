// ======== preprocess ========

#define tsh_PROGRAM_fsh

// ======== input ========

in vec2 texCoord;

// ======== output ========

/* DRAWBUFFERS:2 */
out vec4 outColor0;

// ======== uniform ========

uniform vec2 viewResolution;

uniform sampler2D colortex2;

// ======== constant and function ========

#include "/lib/color.glsl"
#include "/lib/constant.glsl"
#include "/lib/function.glsl"

void main() {

    vec4 color2 = vec4(0.0);

    for(int s = -56; s <= 56; s += 8) {
        color2 += texture(colortex2, texCoord + vec2(0.0, s)/viewResolution) * (1.0 - 0.015625 * abs(s));
    }
    //color2 /= color2.a;

    // ======== write values to output variables ========

    outColor0 = color2;

}