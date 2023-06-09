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

#include "/lib/constant.glsl"
#include "/lib/function.glsl"

void main() {

    vec4 color = texture(colortex0, texCoord);
    //color = texture(shadowcolor0, (gl_FragCoord.xy - 0.5 * viewResolution) / tsh_ShadowMapResolution + 0.5);

    //color.rgb = max(color.rgb, 0.0);

    color = tshf_ColorEncode(color);

    vec3 noise = tshf_Noise(gl_FragCoord.xy / viewResolution).xyz;
    color.rgb += (1.0 / 255.0) * noise;

    // ======== write values to output variables ========

    outColor0 = color;

}