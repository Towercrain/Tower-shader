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

float calcExposure(float brightness) {

    return 0.25 / (brightness + mix(color_NIGHT_VISION_INTENSITY, color_MINIMUM_LIGHT_INTENSITY, nightVision));

}

float calcVignette(vec2 pos) {

    vec2 a = pos - pos * pos;
    float vignette = (45.0 / 17.0) * (a.x * a.y + 0.35);

    return vignette;

}

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
*/
    float exposure = calcExposure(brightness);
    float vignette = calcVignette(texCoord);

    color.rgb *= exposure * vignette;

    color.rgb = color_XYZ_TO_LMS * color_P3_TO_XYZ * color.rgb;
    color.rgb = (0.32903 / 0.35825) * color_TowerShaderToneMap(color.rgb * (0.35825 / 0.32903));
    color.rgb = color_XYZ_TO_P3 * color_LMS_TO_XYZ * color.rgb;

    // ======== write values to output variables ========

    outColor0 = color;
    outColor1 = vec4(brightness, 0.0, 0.0, 1.0);

}