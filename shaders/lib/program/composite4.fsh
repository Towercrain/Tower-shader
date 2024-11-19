// ======== preprocess ========

#define tsh_PROGRAM_fsh

// ======== input ========

in vec2 texCoord;

// ======== output ========

/* DRAWBUFFERS:0 */
out vec4 outColor0;

// ======== uniform ========

uniform vec2 viewResolution;

uniform sampler2D colortex0;
uniform sampler2D colortex2;

// ======== constant and function ========

#include "/lib/color.glsl"
#include "/lib/constant.glsl"
#include "/lib/function.glsl"

void main() {

    vec4 color0 = texture(colortex0, texCoord);

    for(int s = -448; s <= 448; s += 64) {
        color0 += texture(colortex2, texCoord + vec2(s, 0.0)/viewResolution) * min(0.015625 * abs(s), 1.0) * (1.0 / (9.8696 * s * s + 1.0));
        color0 += texture(colortex2, texCoord + vec2(0.0, s)/viewResolution) * min(0.015625 * abs(s), 1.0) * (1.0 / (9.8696 * s * s + 1.0));
    }
    color0 /= color0.a;

    // ======== write values to output variables ========

    outColor0 = color0;

}