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
//uniform sampler2D shadowcolor0;

// ======== constant and function ========

#include "/lib/color.glsl"
#include "/lib/constant.glsl"
#include "/lib/function.glsl"

void main() {

    vec4 color = texture(colortex0, texCoord);
    //color = texture(shadowcolor0, texCoord);

    color.rgb = color_SRGBOETF(color.rgb);

    vec3 noise = tshf_Noise(gl_FragCoord.xy / viewResolution).rgb;
    color.rgb += (1.0 / 255.0) * noise;

    // ======== write values to output variables ========

    outColor0 = color;

}