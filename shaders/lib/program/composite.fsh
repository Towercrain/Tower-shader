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

uniform vec2 viewResolution;
uniform mat4 gbufferProjectionInverse;

uniform sampler2D colortex0;

// ======== constant and function ========

#include "/lib/constant.glsl"
#include "/lib/function.glsl"

const bool colortex1Clear = false;

float calcExposure(float brightness) {

    return 0.4 * pow(brightness, -1.0 / 2.0);

}

float calcVignette(vec2 pos) {

    vec2 a = pos - pos * pos;
    float vignette = (45.0 / 17.0) * (a.x * a.y + 0.35);

    return vignette;

}

vec3 towerShaderToneMap(vec3 color) {

    return 1.0 - 1.0 / ((4.0 * color + 1.0) * color + 1.0);

}

void main() {

    vec4 color = texture(colortex0, texCoord);

    float exposure = calcExposure(brightness);
    float vignette = calcVignette(texCoord);

    color.rgb *= exposure * vignette;

    //color.rgb = 1.0 - exp(-color.rgb);
    color.rgb = towerShaderToneMap(color.rgb);

    // ======== write values to output variables ========

    outColor0 = color;
    outColor1 = vec4(brightness, 0.0, 0.0, 1.0);

}