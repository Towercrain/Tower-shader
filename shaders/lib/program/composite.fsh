// ======== preprocess ========

#define tsh_PROGRAM_fsh

// ======== input ========

in float brightness;
in vec2 texCoord;

// ======== output ========

/* DRAWBUFFERS:01 */
out vec4 outColor0;
out vec4 outColor1;

// ======== uniform ========

uniform float nightVision;
uniform vec2 viewResolution;

uniform mat4 gbufferProjectionInverse;

uniform sampler2D colortex0;

// ======== constant and function ========

#include "/lib/color.glsl"
#include "/lib/constant.glsl"
#include "/lib/function.glsl"

const bool colortex1Clear = false;

void main() {

    vec4 color = texture(colortex0, texCoord);
/*
    vec2 uv = (gl_FragCoord.xy - 0.5 * viewResolution) * (1.0 / 512.0) + 0.5;

    color = vec4(
        exp(4.0 * (2.0 * uv.y - 1.0))
        * clamp(vec3(
            abs(6.0 * fract(uv.x) - 3.0) - 1.0,
            2.0 - abs(6.0 * fract(uv.x) - 2.0),
            2.0 - abs(6.0 * fract(uv.x) - 4.0)
        ), 0.0, 1.0),
        1.0
    );
    color.rgb = color_SRGBEOTF(color.rgb);
    color.rgb = max(color.rgb, 0.0);
*/

    color.rgb = color_XYZ_TO_LMS * color_SRGB_TO_XYZ * color.rgb;

    color.rgb *= tshf_CalcExposure(brightness);
    color.rgb = color_TowerShaderToneMap(color.rgb);

    color.rgb = color_XYZ_TO_SRGB * color_LMS_TO_XYZ * color.rgb;

    // ======== write values to output variables ========

    outColor0 = color;
    outColor1 = vec4(brightness, 0.0, 0.0, 1.0);

}