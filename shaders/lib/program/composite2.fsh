// ======== preprocess ========

#define tsh_PROGRAM_fsh

// ======== input ========

in vec2 texCoord;

// ======== output ========

/* DRAWBUFFERS:02 */
out vec4 outColor0;
out vec4 outColor1;

// ======== uniform ========

uniform vec2 viewResolution;

uniform sampler2D colortex0;
uniform sampler2D colortex2;

// ======== constant and function ========

#include "/lib/color.glsl"
#include "/lib/constant.glsl"
#include "/lib/function.glsl"

void main() {

    vec4 color2 = vec4(0.0);
    const int s = 9;
    for(int i = -s; i <= s; i += s) {
        color2 += texture(colortex2, texCoord + vec2(i, -s)/viewResolution);
        color2 += texture(colortex2, texCoord + vec2(i, 0)/viewResolution);
        color2 += texture(colortex2, texCoord + vec2(i, s)/viewResolution);
    }
    color2 /= color2.a;

    vec4 color0 = texture(colortex0, texCoord);
    color0 += color2;


    // ======== write values to output variables ========

    outColor0 = color0;
    outColor1 = color2;

}